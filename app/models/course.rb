class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :instructor_avatar, AvatarUploader

  STATUS_CODE_0 = 0 #课程状态 规划中
  STATUS_CODE_1 = 1 #课程状态 已发布
  STATUS_CODE_2 = 2 #课程状态 授课中
  STATUS_CODE_3 = 3 #课程状态 已交付
  STATUS_CODE_4 = 4 #课程状态 已取消

  STATUS_CODE_HASH = { 0 => '规划中',1 => '发布中',2 => '授课中',3 => '已交付',4 => '已取消'}

  TYPE_CODE_0   = 0 #现场
  TYPE_CODE_1   = 1 #在线

  TYPE_HASH     = {0 => '现场',1 => '在线'}

  LEVEL_CODE    = ['Level 100', 'Level 200', 'Level 300', 'Level 400']

  CHARGE_TYPE_0 = 0 # 收费
  CHARGE_TYPE_1 = 1 #免费

  CHARGE_TYPE_HASH = {0 => '收费',1 => '免费'}

  CONTENT_TYPE_AX  = 'AX'
  CONTENT_TYPE_CRM = 'CRM'
  CONTENT_TYPE_AX_CRM = '软技能'
  CONTENT_TYPE_QT     = '其他'

  CONTENT_TYPE_ARRAY = %w(AX CRM 软技能 其他)

  CITY_ARRAY = %w(上海市 北京市 广州市 其他城市 在线)

  field :code,    type:String # 课程编码   limit 12 letter
  field :name_cn, type:String # 中文名 limit 128 letter
  field :name_en, type:String # 英文名 limit 128 letter
  field :difficulty_level,type:String #难易程度 Level 100, Level 200, Level 300, Level 400
  field :delivery_type,type:Integer,default:TYPE_CODE_0 # 课程类型
  field :charge_category,type:Integer,default:CHARGE_TYPE_0 #收费
  field :content_type,type:String # 内容类型
  field :status,type:Integer,default:STATUS_CODE_0 #课程状态
  field :audience,type:String # 受众对象  limit 64 letter
  field :instructor,type:String   # 教师姓名 limit 12 letter
  field :instructor_avatar,type:String # 教师头像
  field :instructor_desc,type:String #教师简介 limit 1024 letter
  field :start_date,type:Date
  field :start_time,type:String
  field :end_date,type:Date
  field :end_time,type:String
  field :duration,type:Float #课程持续时间,以天为单位
  field :lim_num,type:Integer #最多容纳人数
  field :description, type: String # 课程描述 2048 leter
  field :city,type:String # 城市  上海，北京，广州，其他城市，在线
  field :address,type:String # 具体地址
  field :classroom,type:String # 课室
  field :evaluation_general,type:Float,default:0.0 #课程总评分
  field :evaluation_instructor,type:Float,default:0.0 #讲师评分
  field :waiting_acctadmin_approval_num,type:Integer,default:0 #等待单位同意的人数
  field :waiting_sysadmin_approval_num,type:Integer,default:0 #单位已同意、等系统管理员接受的人数
  field :valid_registration_num,type:Integer,default:0 # 当前有效报名人数
  field :canceled_num,type:Integer,default:0 # 已取消报名的人数
  field :attendee_num,type:Integer,default:0 # 实际参训人数
  field :price_level1,type:Float # Managed伙伴价格
  field :price_level2,type:Float # Un-managed伙伴价格
  field :price_level3,type:Float # 公众价格
  field :manager_condition,type:String # 匹配短信通知管理员的条件
  field :trainee_condition,type:String # 匹配短信通知学员的条件
  field :notice_content,type:String # 管理员自定义提醒短信内容
  field :notice_at,type:String #上课提醒短信提前多少天发送，可以指定很多个，元素代表提前多少天

  has_many :orders
  has_many :feedbacks
  scope :published, -> {where(status:STATUS_CODE_1)}
  scope :charge, -> {where(charge_category:CHARGE_TYPE_0)}
  scope :uncharge, -> {where(charge_category:CHARGE_TYPE_1)}
  scope :going, -> {where(:start_date.lte => Date.today,:end_date.gte => Date.today)}
  scope :passed, -> {where(status:STATUS_CODE_3)}
  scope :canceld,-> {where(status:STATUS_CODE_4)}
  # after_save :send_msg
  after_save :check_status

  #检查状态是否发生了改变
  def check_status
    if self.status_changed?  #只有线下课程才会发送短信
      if self.status == STATUS_CODE_1 # 发布新课程
        send_new_lesson_msg
      end
      if self.status == STATUS_CODE_3 # 结课
        set_order_passed
      end
      if self.status == STATUS_CODE_4 #取消课程
        set_order_canceled
      end
    else
      check_address_changed
    end
  end

  #检查城市是否发生了改变
  def check_address_changed
    if self.status == STATUS_CODE_1  #只判断处于发布中的课程
      if self.address_changed? #课程城市的变化相当于取消了该课程，并新建了一个新的课程，并且该课程处于开放状态
        mlist = self.orders.effective.map{|e| e.user.mobile}
        SmsWorker.perform_async("lesson_address_changed",mlist,{course_id:self.id.to_s})
      else
        check_time_changed
      end
    end
  end

  #检查时间是否发生了变化
  def check_time_changed
    if self.start_date_changed? || self.start_time_changed?
      mlist = self.orders.effective.map{|e| e.user.mobile}
      SmsWorker.perform_async("lesson_time_changed",mlist,{course_id:self.id.to_s})
    end
  end


  def charge_type
    return '是' if self.charge_category == CHARGE_TYPE_0
    return '否' if self.charge_category == CHARGE_TYPE_1
  end

  #发布了一门新课程，给所有匹配的企业管理员和学员发送开课短信提醒
  def send_new_lesson_msg
    mlist = Company.where(:name.ne => '其他',pri_serv:/#{content_type}/).actived.map{|e| e.manager.try(:mobile)} #企业管理员电话号码
    slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.ax.map{|e| e.mobile} if self.trainee_condition == 'AX'
    slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.crm.map{|e| e.mobile} if self.trainee_condition == 'CRM'
    slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.softskill.map{|e| e.mobile} if self.trainee_condition == '软技能'
    slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.qt.map{|e| e.mobile} if self.trainee_condition == '其他'
    SmsWorker.perform_async("lesson_published_to_manager",mlist,{course_id:self.id.to_s})
    SmsWorker.perform_async("lesson_published_to_student",slist,{course_id:self.id.to_s})
  end

  #课程已经交付，将对应的报名表设置为过期
  def set_order_passed
    self.orders.update_all(passed:true)
  end

  #因课程取消，将所有有效的报名的状态变为取消,并发送取消课程短信
  def set_order_canceled
    self.orders.effective.each do |order|
      order.update_attributes(is_cancel:true,cancel_type:Order::CANCEL_CODE_2,cancel_at:Time.now) #企业管理员取消有效报名
      SmsWorker.perform_async("lesson_canceled_to_student",order.user.mobile,{course_id:self.id.to_s})
    end
  end

  def show_content_type
    self.content_type
  end

  def show_city
    if self.delivery_type == TYPE_CODE_1
      return '在线'
    else
      if self.city.include?('其他城市')
        return self.address.split('市').first + '市'
      else
        return self.city
      end
    end
  end

  def show_address
    if self.delivery_type == TYPE_CODE_0
      unless self.city.include?('其他城市')
        self.city + ' ' + self.address + ' ' + self.classroom
      else
        self.address + ' ' + self.classroom
      end
    else
      self.address || '在线课程'
    end
  end

  # 查查某个课程还剩多少个名额
  def remain_num
    lim_num - valid_registration_num
  end

  #等待单位同意的人数
  def waiting_acctadmin_approval_num
    self.orders.where(:status.ne => Order::STATUS_CODE_1,is_cancel:false).count
  end

  #单位已同意、等系统管理员接受的人数
  def waiting_sysadmin_approval_num
    self.orders.where(status:Order::STATUS_CODE_1,is_cancel:false,:state.ne => Order::STATE_CODE_1).count
  end

  # 当前有效报名人数
  def valid_registration_num
    self.orders.where(state:Order::STATE_CODE_1,is_cancel:false).count
  end
  # 已取消报名的人数
  def canceled_num
    self.orders.where(state:Order::STATE_CODE_1,is_cancel:true).count
  end

  # 实际参训人数
  def attendee_num
    self.orders.where(state:Order::STATE_CODE_1,is_cancel:false,presence:true).count
  end

  #某课程现在是否接受报名
  def open?
    self.status == STATUS_CODE_1
  end


  def self.admin_search(params)
    courses = Course.where(status:params[:status].to_i)
    if params[:code].present?
      courses = courses.where(code:/#{params[:code]}/i)
    end
    if params[:name].present?
      courses = courses.wehre(name:/#{params[:name]}/i)
    end
    if params[:content].present?
      courses = courses.where(content_type:params[:content])
    end
    if params[:city].present?
      courses = courses.where(city:params[:city])
    end
    if params[:start].present?
      courses = courses.where(:start_date.gte => DateTime.parse(params[:start]))
    end
    if params[:end].present?
      courses = courses.where(:end_date.lte => DateTime.parse(params[:end]))
    end
    return courses

  end

  #前端页面搜索
  def self.search(opt)
    para = {}
    para[:t] = opt[:t]
    result =  self.where(status:STATUS_CODE_1)  # 用户可以搜索到筹备中的和发布中的课程

    if opt[:t].present?
      if opt[:t].match(/qt/)
        para[:t] = '其他'
      elsif opt[:t].match(/ax_crm/)
        para[:t] = '软技能'
      elsif opt[:t] == 'f'
        result = result.uncharge
        return result
      end
      result = result.where(content_type:/^#{para[:t].upcase}$/)
      return result
    end
    if opt[:name].present?
      result = result.any_of({:name_cn => /#{opt[:name]}/i},{:name_en => /#{opt[:name]}/i})
      return result
    end
    return result
  end

  #判断某个用户对某个课程是否可以提交反馈
  def can_feed?
    Time.parse("#{self.start_date} #{self.start_time}") <= Time.now #正在授课或者授课结束，可以反馈
  end

  #batch 用，每五分钟检查一次是否有从发布变为授课中的课程
  #batch 用，每五分钟检查一次是否有从授课中变为已交付的课程
  def self.batch_update_status
    self.each do |c|
      if Time.now >= Time.parse("#{c.start_date} #{c.start_time}") && Time.now < Time.parse("#{c.end_date} #{c.end_time}")
        if c.status == Course::STATUS_CODE_1
          c.update_attributes(:status => Course::STATUS_CODE_2)  #将已发布的课程更新为授课中
        end
      end
      if Time.now >= Time.parse("#{c.start_date} #{c.start_time}")
        if c.status == Course::STATUS_CODE_3
          c.update_attributes(:status => Course::STATUS_CODE_2)  #将授课中的课程更新为已交付
          c.orders.update_all(passed:true) # 将关联的订单设置为过期
        end
      end
    end
  end

  #batch 用，每天早晨六点查找有没有今天要发送的上课预提醒短信
  def self.send_pre_notice
    self.each do |c|
      c.notice_at.split(',').each do |d|
        next if d.class != Fixnum
        mlist = c.orders.effective.map{|e| e.user.mobile}.flatten
        if c.start_date - d.day == Date.today
          SmsWorker.perform_async("lesson_pre_notice",mlist,{course_id:c.id.to_s})
        end
      end
    end
  end





end
