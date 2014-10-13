require 'error_enum'
class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  SOURCE_CODE_0 = 0 #报名记录产生自学员自主报名
  SOURCE_CODE_1 = 1 #报名记录产生自企业管理员代报名
  SOURCE_CODE_2 = 2 #报名记录产生自系统管理员代报名

  STATUS_CODE_0 = 0 #企业管理员审核状态  待审核
  STATUS_CODE_1 = 1 #企业管理员审核状态  审核通过
  STATUS_CODE_2 = 2 #企业管理员审核状态  审核拒绝
  STATUS_CODE_HASH = {0 => '待审核',1 => '审核通过',2 => '审核拒绝'}
  STATE_CODE_0  = 0 #系统管理员审核状态值 待审核
  STATE_CODE_1  = 1 #系统管理员审核状态值 审核通过
  STATE_CODE_2  = 2 #系统管理员审核状态值 审核拒绝
  STATE_CODE_HASH = {0 => '待审核',1 => '审核通过',2 => '审核拒绝'}


  CANCEL_CODE_0 = 0 #谁取消的报名  学员
  CANCEL_CODE_1 = 1 #谁取消的报名  企业管理员
  CANCEL_CODE_2 = 2 #谁取消的报名  系统管理员

  field :source, type: Integer,default: SOURCE_CODE_0 # 报名记录产生的来源
  field :status, type: Integer,default: STATUS_CODE_0 # 企业管理员审核状态  
  field :status_at,type:Array,default: []  # 企业管理员审核发生的时间，可能多次改变status值
  field :state, type: Integer,default: STATE_CODE_0  #系统管理员审核状态值
  field :state_at,type:Array,default: [] #系统管理员审核发生的时间，可能多次改变state值
  field :is_cancel,type:Boolean,default: false #该报名是否已经取消
  field :cancel_type, type:Integer #谁取消的报名
  field :cancel_at,type:DateTime # 取消报名的时间
  field :presence,type: Boolean #出席情况
  field :passed,type: Boolean,default: false #该订单是否已经过期

  belongs_to :user
  belongs_to :course

  scope :effective, -> {where(state:STATE_CODE_1,is_cancel:false)}#有效报名,指的是系统管理员审核通过，并且没有被取消的报名

  # def self.cancel(course_id)
  #   self.where(course_id:course_id).update_attributes(is_cancel:true,cancel_type:CANCEL_CODE_2,cancel_at:Time.now)
  # end

  # 学员自己报名的情况
  def self.create_new(params,user_id)
    source  = params[:source] || SOURCE_CODE_0
    state   = params[:state]  || STATE_CODE_0
    status  = params[:status] || STATUS_CODE_0
    user    = User.find(user_id) 
    manager =  user.company.try(:manager)
    params[:data].each do |course_id|
      order = Order.where(course_id:course_id.to_s,user_id:user_id).first
      unless order.present?
        Order.create(user_id:user_id,course_id:course_id)
        if manager && manager.mobile.present?
          #这里有个疑问，如果用户可以批量创建报名的话，那么会给企业管理员发送多条短信，造成短信炸弹
          SmsWorker.perform_async("user_create_order",manager.mobile,{couser_id:course_id,user_id:user_id})  
        end
      end
    end
    return true
  end

  #企业管理员批量创建或修改报名记录
  def self.manager_multiple_create(params,manager_id)
    manager = User.find(manager_id)
    params['data'].values.each do |element|
      course_id = element['c_id']
      user_id   = element['u_id']
      type      = element['type']
      order = Order.where(user_id:user_id,course_id:course_id).first 
      user  = User.find(user_id)
      if order.present?
        status_arr = order.status_at 
        status_arr << Time.now #追加一个新的操作时间，只有涉及到操作status的时候才会记录这个值        
        if type == 'cancel' # 企业管理员取消报名操作
          if order.state != STATE_CODE_1  # 如果不是有效报名，直接删除记录
            order.destroy
            #SmsWorker.perform_async("manager_cancel_uneffective_order",user.mobile,{couser_id:course_id,manager:manager.name})
          else
            order.update_attributes(is_cancel:true,cancel_type:CANCEL_CODE_1,cancel_at:Time.now) #企业管理员取消有效报名
            #SmsWorker.perform_async("manager_cancel_effective_order",user.mobile,{couser_id:course_id,manager:manager.name})
          end
        else # 企业管理员审核通过操作
          if order.status != STATUS_CODE_1 # 只有未审核或者审核未通过的时候才会更改为审核通过
            order.update_attributes(status:STATUS_CODE_1,status_at:status_arr) 
            # 这里企业审核通过，不发送短信到报名学员
          end
        end
      else
        #报名不存在，创建一个新的报名记录，即代学员报名，但是不发送短信
        if type == 'enroll'
          order = Order.create(source:SOURCE_CODE_1,status:STATUS_CODE_1,status_at:[Time.now],user_id:user_id,course_id:course_id)  
        end
      end
    end  
    return true
  end

  #单位管理员查看该单位下某个课程的报名情况
  def self.get_company_list(manager_id,course_id)
    manager = User.find(manager_id)
    uids = manager.employees
    data = []
    self.where(course_id:course_id,:user_id.in =>uids).map do |e|
      obj = {}
      obj['c_name']     = e.course.name_en
      obj['u_name']     = e.user.name
      obj['status']     = STATUS_CODE_HASH[e.status]
      obj['state']      = STATE_CODE_HASH[e.state]
      obj['oid']        = e.id.to_s 
      obj['c_id']       = e.course.id.to_s
      obj['u_id']       = e.user.id.to_s
      obj['presence']   = e.passed ? (e.presence ? 'No' : 'Yes') : '--'
      obj['is_cancel']  = e.is_cancel
      obj['can_cancel'] = e.course.start_date - Date.today > 3 ? true : false
      obj['is_check']   = e.status == STATUS_CODE_0 ? false : true
      obj['check_ok']   = e.status == STATUS_CODE_1 ? true : false
      data << obj
    end
    return data
  end

  #企业管理员审核操作
  def self.check(params,manager_id,is_refuse=false)
    manager = User.find(manager_id)
    course  = Course.find(params['cid'])
    user    = User.find(params['uid']) 
    o = Order.where(course_id:params['cid'],user_id:params['uid']).first
    if o.present?
      if is_refuse # 拒绝操作
        if o.status != STATUS_CODE_2
          status_arr = o.status_at
          status_arr << Time.now
          o.update_attributes(status:STATE_CODE_2,status_at:status_arr)
          #SmsWorker.perform_async("manager_refused_order",user.mobile,{couser_id:course_id,manager:manager.name})  # 企业管理员拒绝报名，发送短信
          return true
        else
          return true
        end
      else # 同意操作
        if o.status != STATUS_CODE_1
          status_arr = o.status_at
          status_arr << Time.now
          o.update_attributes(status:STATUS_CODE_1,status_at:status_arr)  # 同意报名操作，不发短信         
        else
          return true
        end
      end
    else
      return ErrorEnum::ORDER_NOT_EXIST
    end
  end

  #取消报名操作
  def self.cancel(id,user_id)
    order = self.find(id)
    if order
      course_id = order.course.id.to_s
      u = User.find(user_id)
      user = order.user

      if u.is_manager?
        if order.state == STATE_CODE_1  # 取消有效报名
          if order.start_date - Date.today > 3
            order.count_effictive_course
            order.reset_card_num #计算学习卡
            return order.update_attributes(is_cancel:true,cancel_type:CANCEL_CODE_1,cancel_at:Time.now) #企业管理员取消有效报名
            #SmsWorker.perform_async("manager_cancel_effective_order",user.mobile,{couser_id:course_id,manager:u.name})            
          else
            return ErrorEnum::ORDER_CAN_NOT_CANCEL
          end
        else #取消无效报名
          if order.status == STATUS_CODE_0
            #如果该报名还未被审核就被删除，则发短信通知，否则不发通知
            #SmsWorker.perform_async("manager_cancel_uneffective_order",user.mobile,{couser_id:course_id,manager:u.name})
          end
          return order.destroy             
        end
      else
        #用户自己取消报名
        if order.state == STATE_CODE_1  # 取消有效报名
          if order.start_date - Date.today > 3
            order.count_effictive_course
            order.reset_card_num #计算学习卡
            order.update_attributes(is_cancel:true,cancel_type:CANCEL_CODE_0,cancel_at:Time.now) #用户自己取消有效报名  
            manager = u.company.manager
            if manager.present? && manager.mobile.present? #注意这里没有发送短信到管理员，下面的代码不用执行，所以保持注释掉即可
              #SmsWorker.perform_async("user_cancel_effective_order",manager.mobile,{couser_id:course_id,user:u.name}) #用户自主取消了有效报名，发短信到对应的管理员 
            end
            return true          
          else
            return ErrorEnum::ORDER_CAN_NOT_CANCEL
          end
        else #取消无效报名
          return order.destroy      
        end        
      end
    else
      return ErrorEnum::ORDER_NOT_EXIST
    end
  end

  # 系统管理员取消报名
  def self.admin_cancel(params)
    Order.where(:id.in => params[:data]).update_all(is_cancel:true,cancel_type:CANCEL_CODE_2,cancel_at:Time.now)
    params[:data].each do |oid|
      o = Order.find(oid)
      if o.present?
        if o.state == STATE_CODE_1  # 取消有效报名 系统管理员删除有效报名的时候没有三天时间的限制
          o.update_attributes(is_cancel:true,cancel_type:CANCEL_CODE_2,cancel_at:Time.now) #企业管理员取消有效报名
          o.count_effictive_course
          o.reset_card_num
          o.set_company_enroll
          #注意，下面的代码不用打开，因为系统管理员取消有效报名的时候不需要发短信通知相关人
          #SmsWorker.perform_async("admin_cancel_effective_order",user.mobile,{couser_id:o.course_id.to_s})            
        else #取消无效报名
          if o.status == STATUS_CODE_0 && order.state == STATE_CODE_0
            #只有系统管理员和企业管理员都没有审核的情况下发送 短信
            #注意下面这条短信不用发送
            #SmsWorker.perform_async("admin_cancel_uneffective_order",user.mobile,{couser_id:course_id})   # 系统管理员删除无效报名，发送短信到对应的报名人 
          end
          order.destroy    
        end
      end
    end
    return true
  end

  # 系统管理员代理学员报名
  def self.generate_proxy_order(params)
    params[:uarr].each do |uid|
      order = Order.where(user_id:uid,course_id:params[:cid]).first
      unless order.present?
        order = Order.create(source:SOURCE_CODE_2,state:STATE_CODE_1,state_at:[Time.now],user_id:uid,course_id:params[:cid])
        order.count_effictive_course(1)
        order.reset_card_num(1) # 计算学习卡
        order.set_company_enroll(1)
        user = User.find(uid)
        #注意下面这条短信也不发送
        #SmsWorker.perform_async("admin_generate_order",user.mobile,{couser_id:params[:cid]}) # 发送系统审核拒绝的短信
      end
    end
    return true
  end


  # 系统管理员做订单检索
  def self.admin_search(params)
    course = Course.all
    if params[:code].present?
      course = course.where(code:/#{params[:code]}/)
    end
    if params[:name].present?
      course = course.where(name_en:/#{params[:name]}/)
    end
    if params[:start].present?
      course = course.where(:start_date.gte => DateTime.parse(params[:start]))
    end
    if params[:end].present?
      course = course.where(:end_date.lte => DateTime.parse(params[:end]))
    end
    if params[:content].present?
      course = course.where(content_type:params[:content])
    end
    if params[:city].present?
      course = course.where(city:params[:city])
    end
    if params[:t] == 'o'
      course = course.published
    elsif params[:t] == 'n'
      course = course.going
    elsif params[:t] == 'c'
      course = course.canceld
    else
      course = course.passed
    end

    orders = course.map{|e| e.orders}.flatten
    # binding.pry
    if params[:company].present?
      company = Company.find(params[:company])
      uids = company.users.map{|e| e.id.to_s}
      # orders = orders.where(:user_id.in => uids)
      orders = orders.select{|e| uids.include?(e.user_id.to_s)}
    end

    if params[:state].present?
      # orders = orders.where(state:params[:state].to_i)
      orders = orders.select{|e| e.state == params[:state].to_i}
    end

    if params[:status].present?
      # orders = orders.where(status:params[:status].to_i)
      orders = orders.select{|e| e.status == params[:status].to_i}
    end

    if params[:cancel].present?
      if params[:cancel] == 'true'
        # orders = orders.where(is_cancel:true)
        orders = orders.select{|e| e.is_cancel == true}
      else
        # orders = orders.where(is_cancel:false)
        orders = orders.select{|e| e.is_cancel == false}
      end
    end

    return orders
  end

  # 系统管理员审核报名操作
  def self.check_order(params)
    params[:data].each do |oid|
      o = Order.find(oid)
      user = o.user

      state_at = o.state_at
      state_at << Time.now  

      if params[:type] == 'allow'
        o.update_attributes(state:STATE_CODE_1,state_at:state_at) if o.state != STATE_CODE_1 # 只有在订单没有审核或者审核拒绝的情况下做允许的操作
        o.count_effictive_course(1)
        o.reset_card_num(1)
        o.set_company_enroll(1)
        #SmsWorker.perform_async("admin_allow_order",user.mobile,{couser_id:o.course_id}) # 发送系统审核通过的短信
      else
        o.update_attributes(state:STATE_CODE_2,state_at:state_at) if o.state != STATE_CODE_2 # 只有在订单没有审核或者审核通过的情况下做拒绝操作
        o.count_effictive_course
        o.reset_card_num
        o.set_company_enroll
        #SmsWorker.perform_async("admin_refuse_order",user.mobile,{couser_id:o.course_id}) # 发送系统审核拒绝的短信
      end
    end
    return true
  end

  # 系统管理员标示课程的出席情况
  def self.make_attend(params)
    params[:data].each do |oid|
      o = Order.find(oid)
      o.update_attributes(presence:false) if params[:type] == 'absent'
      o.update_attributes(presence:true)  if params[:type] == 'attend'
    end
    return true
  end 

  #系统管理员审核通过后，计算个人的有效报名情况
  def count_effictive_course(type=0)
    user = self.user
    course = self.course
    if type == 0
      c_count = user.course_count - 1 #该用户的有效报名课程数量加1
      c_count = 0 if c_count < 0
      duration = user.course_manday_count - course.duration #该用户的有效报名天数
      duration = 0 if duration < 0
    else
      c_count = user.course_count + 1 #该用户的有效报名课程数量加1
      duration = user.course_manday_count + course.duration #该用户的有效报名天数(因为每个人生成一个订单，所以人天数就等于人数乘以课程持续时间数)
    end

    user.update_attributes(course_count:c_count,course_manday_count:duration) 
  end

  #每次系统管理员审核通过或者拒绝，都要重新计算学习卡中计数量
  def reset_card_num(type=0)
    company = self.user.company
    course  = self.course
    if company.present?
      card = company.cards.first
      if card.present?
        if type == 0 # 0代表取消/拒绝报名
          if card.quantity_used > 0
            quantity = (card.quantity_used - course.duration).round(2)
            card.update_attributes(quantity_used:quantity)  #学习卡已使用的人天数减少(发生在报名已生效,后来又取消/拒绝的情况)
          end
        else #代表审核通过报名
          quantity = (card.quantity_used.to_f + course.duration.to_f).round(2)
          card.update_attributes(quantity_used:quantity)  #学习卡已使用的人天数增加   
          if card.quantity_used >= card.quantity_purchased
            card.update_attributes(status_execution:Card::EXEC_STATUS_2,finished_at:Date.today)
          end
        end
      end
    end
  end

  def set_company_enroll(type=0)
    company_id = self.user.company.id.to_s
    course = self.course
    if company_id.present?
      company = Company.find(company_id)
      if company.present?
        if type == 0 # 0代表取消/拒绝报名
          if company.enroll_count > 0
            quantity = (company.enroll_count - course.duration).round(2)
            company.update_attributes(enroll_count:quantity) 
          end
        else #代表审核通过报名
          quantity = (company.enroll_count + course.duration).round(2)
          company.update_attributes(enroll_count:quantity) 
        end
      end
    end    
  end


  def show_state
    return '待审核'   if self.state == STATE_CODE_0
    return '审核通过' if self.state == STATE_CODE_1
    return '审核拒绝' if self.state == STATE_CODE_1
  end

  def show_status
    return '待审核'   if self.status == STATUS_CODE_0
    return '审核通过' if self.status == STATUS_CODE_1
    return '审核拒绝' if self.status == STATUS_CODE_2   
  end

  def cancel_or_not
    return '已取消' if self.is_cancel == true
    return '未取消' if self.is_cancel == false
  end

  def can_cancel
    self.course.start_date - Date.today >= 3 && self.is_cancel == false
  end


end
