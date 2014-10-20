require 'encryption'
require 'error_enum'
require 'find_tool'
class User
  include Mongoid::Document
  include FindTool
  include Mongoid::Timestamps

  attr_accessor :ref,:ordered

  EmailRexg  = '\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z'
  MobileRexg = '^(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$' 

  ROLE_ADMIN = 1 # 系统管理员   
  ROLE_MANAGER = 2 # 企业管理员
  ROLE_EMPLOYEE = 3 # 普通用户
  ROLE_VIEW     = 4 #查看员
  ROLE_HASH = {1 => '系统管理员',2 => '企业管理员',3 => '普通用户', 4 => '查看员'}
  
  POSITION_ARRAY = ['销售', '售前顾问', '项目经理', '应用顾问',  '技术顾问',  '开发顾问', '其他']

  CITY_ARRAY = ['上海','北京','广州','其他']

  INTEREST_ARRAY = ['AX培训','CRM培训','软技能培训']

  CREATER_HASH = {1 => '系统管理员',2 => '企业管理员', 3 => '主动注册'}
    

  STATUS_ACTIVED = 1
  STATUS_INACTIVED = 0

  STATUS_HASH = { 1 => '活跃', 0 => '停用'}

  field :name, type: String
  field :email, type: String
  field :mobile, type: String
  field :password, type: String
  field :role_of_system, type: Integer,:default => 3 #系统角色
  field :type_of_position, type: String #工作类型
  field :city,type: String # 距您最近的城市
  field :ax,type: Boolean,default:true #是否对AX培训感兴趣
  field :crm, type: Boolean,default:true #是否对CRM培训感兴趣
  field :softskill,type: Boolean,default:true #是否对软技能培训感兴趣(AX+CRM)
  field :status, type: Integer,default:STATUS_ACTIVED #状态
  field :course_count,type:Integer,default:0 #有效报名课程数
  field :course_manday_count,type: Float,default:0 # 有效报名人天数
  field :qq, type: String
  field :wechart, type: String
  field :skype, type: String
  field :creater,type:String # 创建人 如果是自己注册，这个字段的值为空，否则为创建人的id
  field :updater,type:String # 最近修改人  

  belongs_to :company,class_name: "Company",inverse_of: :user

  has_many :companies,class_name: "Company",inverse_of: :manager

  has_many :orders,class_name: "Order",inverse_of: :user

  has_many :feedbacks

  scope :except_admin_and_viewer, ->{ any_of({:role_of_system => ROLE_MANAGER},{:role_of_system => ROLE_EMPLOYEE})}

  scope :actived, -> {where(status:STATUS_ACTIVED)}
  scope :ax, -> {where(ax:true)}
  scope :crm, -> {where(crm:true)}
  scope :softskill, -> {where(softskill:true)}
  scope :qt, -> {where(crm:false,ax:false,softskill:false)}#其他课程


  def self.create_admin(email,mobile)
    password = make_encrypt('111111')
    self.create(name:'admin',email:email,mobile:mobile,role_of_system:ROLE_ADMIN,password:password)
  end

  #注册用户
  def self.regist(opt,is_admin=false,is_manager=false,creater=nil)
    #is_admin 标示当前的添加用户行为是否由管理员进行
    #is_manager 标示当前的添加用户行为是否由企业管理员进行
    #creater  表示创建人是谁

    account = {}
    account[:name]              = opt[:name]
    account[:email]             = opt[:email].to_s.downcase
    account[:mobile]            = opt[:mobile]
    account[:role_of_system]    = opt[:role_of_system] || ROLE_EMPLOYEE
    account[:type_of_position]  = opt[:type_of_position] || '销售'
    account[:creater]           = creater
    opt[:password]              = opt[:password].downcase
    account[:company_id]        = opt[:company_id] if opt[:company_id].present?
    return ErrorEnum::MOBILE_ERROR unless opt[:mobile].match(/#{MobileRexg}/i)
    return ErrorEnum::NAME_BLANK unless account[:name].present? 
    return ErrorEnum::EMAIL_BLANK unless account[:email].present? unless is_admin
    return ErrorEnum::MOBILE_BLANK unless account[:mobile].present? unless is_admin
    return ErrorEnum::PASSWORD_BLANK unless opt[:password].present?

    account[:password] = make_encrypt(opt[:password])


    user = self.where(email:account[:email]).actived.first if account[:email].present?
    return ErrorEnum::EMAIL_EXIST if user.present?

    user = self.where(mobile:account[:mobile]).actived.first  if(!user.present? && account[:mobile].present?)
    return ErrorEnum::MOBILE_EXIST if user.present?

    if is_manager
      manager = User.find(creater)
      opt[:company_id] = manager.companies.first.id.to_s
      account[:company_id] = opt[:company_id]
    end
    # company = Company.where(id:opt[:company_id]).first unless is_admin
    company = Company.where(id:opt[:company_id]).first

    unless is_admin
      return ErrorEnum::COMPANY_NOT_EXIST unless company.present?
    end
    user = self.create(account)
    if account[:role_of_system].to_i == ROLE_MANAGER && company.present?
      company.manager.update_attributes(role_of_system:ROLE_EMPLOYEE)
      user.company.update_attributes(manager_id:user.id.to_s)
    end
    if is_admin
      if user.mobile.present?
        if user.is_manager?
          #系统管理员添加企业管理员
          #SmsWorker.perform_async("admin_add_manager",user.mobile,{pwd:opt[:password]})
        elsif user.is_viewer?
          #系统管理员添加观察员
          #SmsWorker.perform_async("admin_add_viewer",user.mobile,{pwd:opt[:password]})
        else
          #系统管理员添加学员
          SmsWorker.perform_async("admin_add_user",user.mobile,{pwd:opt[:password]})
        end
      end      
    elsif is_manager
      #企业管理员添加学员
      #SmsWorker.perform_async("manager_add_user",user.mobile,{pwd:opt[:password],company:manager.companies.first.name})
    else 
      #用户自己注册
      if company.present? && company.manager.present? && company.manager.mobile.present?
        manager_mobile = company.manager.mobile
        #这里有个疑问，普通用户注册后还有必要通知其选择的企业的管理员么，系统里没有涉及到注册员工需要企业管理员审核的功能
        #SmsWorker.perform_async("user_regist",manager_mobile,{user:user.name})
      end
    end
    return user
  end

  #登录用户
  def self.login(opt)
    email_mobile =  opt[:email_mobile].to_s.downcase
    password     =  opt[:password].to_s.downcase
    user = self.find_by_email_or_mobile(email_mobile)
    return ErrorEnum::USER_NOT_EXIST unless user.present?
    return ErrorEnum::PASSWORD_ERROR if user.password != make_encrypt(password)
    if user.is_admin? || user.is_viewer?
      unless opt[:ref].present?
        user.write_attribute(:ref,'/admin/courses')  
      else
        user.write_attribute(:ref,opt[:ref])  
      end
      
    end
    
    if user.is_manager?
      unless opt[:ref].present?
        user.write_attribute(:ref,'/manager/users') 
      else
        user.write_attribute(:ref,opt[:ref])  
      end
    end
    if user.is_employee?
      unless opt[:ref].present?
        user.write_attribute(:ref,'/user/users')
      else
        user.write_attribute(:ref,opt[:ref])  
      end      
    end
    
    return user
  end

  def self.find_pwd(mobile)
    u = User.where(mobile:mobile).first
    return ErrorEnum::USER_NOT_EXIST unless u.present? 
    new_pwd = Random.rand(999999)
    SmsWorker.perform_async("find_password",mobile,{pwd:new_pwd})
    new_pwd = make_encrypt(new_pwd)
    u.update_attributes(password:new_pwd)
  end

  def self.check_exist(opt)
    email  = opt[:email].to_s.downcase
    mobile = opt[:mobile].to_s.downcase
    id     = opt[:id].to_s
    if email.present?
      user = self.where(email:email).actived.first
    else
      user = self.where(mobile:mobile).actived.first 
    end
    user = nil if id.present? && user.try(:id).to_s == id  
    return user
  end


  def self.update_pwd(user,opt)
    password = opt[:password].downcase
    password = make_encrypt(password)
    user.update_attributes(password:password)
    return user
  end

  def self.search_manager(opt)
    account = opt[:account]
    user = self.where(name:/#{account}/) 
    user = self.where(email:/#{account}/)  unless user.present?
    user = self.where(mobile:/#{account}/) unless user.present?
    return user
  end

  def self.admin_search(opt)
    result = self.all
    if opt['name'].present?
      result = result.where(name:/#{opt['name']}/)
    end
    if opt['email'].present?
      result = result.where(email:/#{opt['email']}/)
    end
    if opt['mobile'].present?
      result = result.where(mobile:/#{opt['mobile']}/)
    end
    if opt['role'].present?
      result = result.where(role_of_system:opt['role'].to_i)
    end
    if opt['position'].present?
      result = result.where(type_of_position:opt['position'])
    end
    if opt['company'].present?
      result = result.where(company_id:opt['company'])
    end
    if opt['city'].present?
      result = result.where(city:/#{opt['city']}/)
    end
    if opt['interest'].present?
      if opt['interest'] == 'AX培训'
        result = result.where(ax:true)
      elsif opt['interest'] == 'CRM培训'
        result = result.where(crm:true)
      elsif opt['interest'] == '软技能培训'
        result = result.where(softskill:true)
      end
    end

    if opt['creater'].present?
      if opt['creater'] == '1'
        tmp_id_arr = self.where(role_of_system:User::ROLE_ADMIN).map{|e| e.id.to_s}
        result = result.where(:creater.in => tmp_id_arr)
      elsif opt['creater'] == '2'
        tmp_id_arr = self.where(role_of_system:User::ROLE_MANAGER).map{|e| e.id.to_s}
        result = result.where(:creater.in => tmp_id_arr)
      elsif opt['creater'] == '3'
        result = result.where(:creater => nil)
      end
    end

    if opt['status'].present?
      result = result.where(status:opt['status'].to_i)
    end 

    if opt['start'].present?
      result = result.where(:created_at.gte => DateTime.parse(opt['start']))
    end
    if opt['end'].present?
      result = result.where(:created_at.lte => DateTime.parse(opt['end']))
    end

    return result    
  end

  def self.manager_search(opt,current_user_id)
    current_user = self.find(current_user_id)
    company = current_user.companies.first
    result = self.where(company_id:company.id.to_s)
    if opt['name'].present?
      result = result.where(name:/#{opt['name']}/)
    end
    if opt['email'].present?
      result = result.where(email:/#{opt['email']}/)
    end
    if opt['mobile'].present?
      result = result.where(mobile:/#{opt['mobile']}/)
    end

    if opt['position'].present?
      result = result.where(type_of_position:opt['position'])
    end

    if opt['city'].present?
      result = result.where(city:opt['city'])
    end
    if opt['interest'].present?
      if opt['interest'] == 'AX培训'
        result = result.where(ax:true)
      elsif opt['interest'] == 'CRM培训'
        result = result.where(crm:true)
      elsif opt['interest'] == '软技能培训'
        result = result.where(softskill:true)
      end
    end

    if opt['start'].present?
      result = result.where(:created_at.gte => DateTime.parse(opt['start']))
    end
    if opt['end'].present?
      result = result.where(:created_at.lte => DateTime.parse(opt['end']))
    end

    return result  
  end


  def self.update_info(opt,inst,updater)
    u = User.where(email:opt[:email].downcase,:id.ne => inst.id.to_s).first
    return ErrorEnum::EMAIL_EXIST if u.present?
    u = User.where(mobile:opt[:mobile] .downcase,:id.ne => inst.id.to_s).first
    return ErrorEnum::MOBILE_EXIST if u.present?
    opt[:updater]  = updater  
    if opt[:password].present?
      opt[:password] =  self.make_encrypt(opt[:password]) 
    else
      opt.delete('password')
    end
    if opt[:company_id].present?
      company = Company.find(opt[:company_id])
      if opt[:role_of_system].to_i ==  ROLE_MANAGER
        company.manager.update_attributes(role_of_system:ROLE_EMPLOYEE)
        company.update_attributes(manager_id:inst.id.to_s)
      end
    end
    inst.update(opt)
    return inst
  end

  def self.match_course_student(content_type)
    return self.where(role_of_system:ROLE_EMPLOYEE).actived.ax.count if content_type == 'AX'
    return self.where(role_of_system:ROLE_EMPLOYEE).actived.crm.count if content_type == 'CRM'
    return self.where(role_of_system:ROLE_EMPLOYEE).actived.ax.crm.count if content_type == 'AX+CRM'
  end


  #系统管理员为学员代理报名的时候做的代理搜索
  def self.search_proxy(params)
    course = Course.find(params['proxy_cid'])

    users = self.actived
    if params['company'].present?
      users = self.where(company_id:params[:company]).actived
    end
    if params[:name].present?
      users = users.where(name:params[:name].to_s.downcase)
    end
    if params[:email].present?
      users = users.where(email:params[:name].to_s.downcase)
    end
    if params[:mobile].present?
      users = users.where(mobile:params[:mobile])
    end
    data = []
    users.each do |user|
      tmp_obj = {}
      tmp_obj['name'] = user.name
      tmp_obj['uid']  = user.id.to_s
      tmp_obj['email'] = user.email
      order = user.orders.where(course_id:params['proxy_cid']).first
      if order.present?
        tmp_obj['ordered'] = true
      else
        tmp_obj['ordered'] = false
      end
      data << tmp_obj
    end
    return data
  end



  #我的课程
  def my_course(opt)
    if opt[:t] == 'w' # 我等待上的课
      result = self.orders.where(is_cancel:false,passed:false)
    elsif opt[:t] == 'p' #我上过的课
      result = self.orders.where(is_cancel:false,passed:true,state:Order::STATE_CODE_1)
    elsif opt[:t] == 'n'#我正在上的课
      c_id_arr = Course.where(:start_date.lte => Date.today,:end_date.gte => Date.today).map(&:id)
      result = self.orders.where(is_cancel:false,:course_id.in => c_id_arr,state:Order::STATE_CODE_1)
    else #我取消的课
      result = self.orders.where(state:Order::STATE_CODE_1,is_cancel:true)
    end
    return result
  end

  #查询某个用户的反馈
  def get_feedbacks(params)
      course_id = self.orders.where(is_cancel:false,state:Order::STATE_CODE_1).map{|e| e.course_id.to_s}
      courses = Course.where(:id.in => course_id,:status.in => [Course::STATUS_CODE_2,Course::STATUS_CODE_3])
      courses = courses.select{|e| e.feedbacks.length <= 0}
      feedbacks = self.feedbacks
      data = {courses:courses,feedbacks:feedbacks}

      return data
  end

  def manager_feedbacks(params)
    user_ids = self.employees
    if params[:t] == 'w' #等待填写的反馈
      course_id = Order.where(is_cancel:false,state:Order::STATE_CODE_1,:user_id.in => user_ids).map{|e| e.course_id.to_s}
      courses = Course.where(:id.in => course_id,:status.in => [Course::STATUS_CODE_2,Course::STATUS_CODE_3])
      courses = courses.select{|e| e.feedbacks.length <= 0}
    else #已经填写的反馈
      courses = Feedback.where(:user_id.in => user_ids).map{|e| e.course}.flatten
    end
    return courses    
  end

  #判断某个用户是否报名了某个课程
  def enrolled?(course_id)
    self.orders.map(&:course_id).map{|e| e.to_s}.include?(course_id)
  end

  def can_cancel?(course_id)
    course = Course.find(course_id)
    order = Order.where(course_id:course.id.to_s,user_id:self.id.to_s,is_cancel:false).first
    order && enrolled?(course_id) && course.start_date - Date.today > 3 ? true : false
  end


  #企业管理员查找自己公司员工的id
  def employees
    uids = self.companies.first.users.actived.map{|e| e.id.to_s}
  end
  #企业管理员查看相关课程
  def manager_courses(params)
    uids = self.employees
    if params[:t] == 'o' # 开放中的课程
      result =  Course.published
      if params[:name].present?
        result = result.where(name_en:/#{params[:name]}/)
      end

      if params[:code].present?
        result = result.where(code:/#{params[:code]}/)
      end

      if params[:content].present?
        result = result.where(content_type:/#{params[:content]}/)
      end

      if params[:city].present?
        result = result.where(city:params[:city])
      end

      if params[:start].present?
        result = result.where(:start_date.gte => DateTime.parse(params[:start]))
      end 

      if params[:end].present?
        result = result.where(:end_date.lte => DateTime.parse(params[:end]))
      end

      return result

    end

    if params[:t] == 'w' #已报名的课程
      cids = Order.where(:user_id.in => uids,:is_cancel => false,:passed => false).map{|e| e.course_id.to_s}.uniq
      result =  Course.published.where(:id.in => cids)
      return result
    end

    if params[:t] == 'n' # 进行中的课程
      cids = Course.going.map{|e| e.id.to_s}
      result =  Order.where(:user_id.in => uids,:is_cancel => false,:passed => false,:state => Order::STATE_CODE_1,:course_id.in => cids).map{|e| e.course}.flatten
      return result
    end

    if params[:t] == 'p' # 参与过的课程
      cids = Course.passed.map{|e| e.id.to_s}
      result =  Order.where(:user_id.in => uids,:is_cancel => false,:passed => true,:state => Order::STATE_CODE_1,:course_id.in => cids).map{|e| e.course}.flatten
      return result
    end

    if params[:t] == 'c' # 取消的课程
      result =  Order.where(:user_id.in => uids,:is_cancel => true,:state => Order::STATE_CODE_1).map{|e| e.course}.flatten
      return result
    end


  end

  #企业管理员批量添加报名
  def do_multiple_order(params)
    result = []
    employees =  self.companies.first.users.actived
    Course.where(:id.in => params[:data]).each do |course|
      tmp_hash = {}
      tmp_hash['c_id']         = course.id.to_s
      tmp_hash['c_code']       = course.code
      tmp_hash['c_name']       = course.name_en
      tmp_hash['c_city']       = course.city
      tmp_hash['c_start']      = course.start_date.strftime('%F')
      tmp_hash['c_instructor'] = course.instructor
      tmp_hash['c_remain']     = course.remain_num

      e_arrs = []
      employees.each do |e|
        tmp_employer = {}
        tmp_employer['e_id']        = e.id.to_s
        tmp_employer['e_name']      = e.name
        tmp_employer['e_email']     = e.email
        tmp_employer['e_mobile']    = e.mobile
        tmp_employer['can_cancel']  = course.start_date - Date.today > 3 ? true : false
        tmp_employer['e_enroll']    = e.orders.where(is_cancel:false,course_id:course.id.to_s).first.present? ? true : false
        e_arrs << tmp_employer
      end

      tmp_hash['e_arr'] = e_arrs
      result << tmp_hash
    end
    return result
  end


  def is_admin?
    return self.role_of_system == ROLE_ADMIN
  end

  def is_viewer?
    return self.role_of_system == ROLE_VIEW
  end

  def is_manager?
    return self.role_of_system == ROLE_MANAGER
  end

  def is_employee?
    return self.role_of_system == ROLE_EMPLOYEE
  end


  private 

  def self.make_encrypt(password)
    password = Encryption.encrypt_password(password)
  end

end
