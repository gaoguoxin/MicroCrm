require 'encryption'
require 'error_enum'
require 'find_tool'
class User
  include Mongoid::Document
  include FindTool
  include Mongoid::Timestamps

  attr_accessor :ref

  EmailRexg  = '\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z'
  MobileRexg = '^(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$' 

  ROLE_ADMIN = 1 # 系统管理员   
  ROLE_MANAGER = 2 # 企业管理员
  ROLE_EMPLOYEE = 3 # 普通用户
  ROLE_VIEW     = 4 #查看员
  ROLE_HASH = {1 => '系统管理员',2 => '企业管理员',3 => '普通用户', 4 => '查看员'}
  
  POSITION_HASH = {1 => '销售',2 => '售前顾问',3 => '项目经理', 4 => '应用顾问', 5 => '技术顾问', 6 => '开发顾问', 7 => '其他'}

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
  field :ax,type: Boolean #是否对AX培训感兴趣
  field :crm, type: Boolean #是否对CRM培训感兴趣
  field :softskill,type: Boolean #是否对软技能培训感兴趣
  field :status, type: Integer,default:STATUS_ACTIVED #状态
  field :course_count,type:Integer #有效报名课程数
  field :course_manday_count,type: Integer # 有效报名人天数
  field :qq, type: String
  field :wechart, type: String
  field :skype, type: String
  field :creater,type:String # 创建人
  field :updater,type:String # 最近修改人  

  belongs_to :company

  has_many :companies,class_name: "Company",inverse_of: :manager

  scope :except_admin_and_viewer, ->{ any_of({:role_of_system => ROLE_MANAGER},{:role_of_system => ROLE_EMPLOYEE})}
  scope :actived, -> {where(:status => STATUS_ACTIVED)}
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
    account[:creater]           = creater
    opt[:password]              = opt[:password].downcase
    
    return ErrorEnum::NAME_BLANK unless account[:name].present? 
    return ErrorEnum::EMAIL_BLANK unless account[:email].present? unless is_admin
    return ErrorEnum::MOBILE_BLANK unless account[:mobile].present? unless is_admin
    return ErrorEnum::PASSWORD_BLANK unless opt[:password].present?

    account[:password] = make_encrypt(opt[:password])

    #exist_user = false

    #user = self.find_by_email(account[:email])
    user = self.where(email:account[:email]).actived.first
    return ErrorEnum::EMAIL_EXIST if user.present?
    #user = self.find_by_mobile(account[:mobile]) if(!user.present? && account[:mobile].present?)
    user = self.where(mobile:account[:mobile]).actived.first  if(!user.present? && account[:mobile].present?)
    return ErrorEnum::MOBILE_EXIST if user.present?
    # exist_user = true if user.present?
    # return ErrorEnum::USER_EXIST if exist_user
    company = Company.where(id:opt[:company_id]).first unless is_admin
    return ErrorEnum::COMPANY_NOT_EXIST unless company.present? unless is_admin
    user = self.create(account)
    
    if is_admin
      if user.mobile.present?
        if user.is_manager?
          #系统管理员添加企业管理员
          #SmsWorker.perform_async("admin_add_manager",user.mobile,{password:opt[:password]})
        elsif user.is_viewer?
          #系统管理员添加观察员
          #SmsWorker.perform_async("admin_add_viewer",user.mobile,{password:opt[:password]})
        else
          #系统管理员添加学员
          #SmsWorker.perform_async("admin_add_user",user.mobile,{password:opt[:password]})
        end
      end      
    elsif is_manager
      #企业管理员添加学员
      #SmsWorker.perform_async("manager_add_user",user.mobile,{password:opt[:password]})
    else 
      #用户自己注册
      manager_mobile = company.manager.mobile
      #SmsWorker.perform_async("user_regist",manager_mobile,{user:user.id.to_s})
    end
    return user
  end

  #登录用户
  def self.login(opt)
    email_mobile =  opt[:email_mobile].to_s.downcase
    password     =  opt[:password].downcase
    user = self.find_by_email_or_mobile(email_mobile)
    return ErrorEnum::USER_NOT_EXIST unless user.present?
    return ErrorEnum::PASSWORD_ERROR if user.password != make_encrypt(password)
    user.write_attribute(:ref,'/admin/courses') if user.is_admin? || user.is_viewer?
    user.write_attribute(:ref,'/manager/users') if user.is_manager?
    user.write_attribute(:ref,'/user/users') if user.is_employee?
    return user
  end

  def self.check_exist(opt)
    email  = opt[:email].to_s.downcase
    mobile = opt[:mobile].to_s.downcase
    if email.present?
      user = self.where(email:email).actived.first  
    else
      user = self.where(mobile:mobile).actived.first 
    end
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
    user = self.find_by_email(account)  if account.match(/#{EmailRexg}/i)
    user = self.find_by_mobile(account) unless user.present?
    return user
  end

  def self.search(opt)
    User.except_admin_and_viewer
  end


  def update_info(opt)
    opt.each_pair do |k,v|
      k = v.downcase.strip!
      user = User.find_by_col("#{k}",v,self.id.to_s)
      if user.present?
        return ErrorEnum::EMAIL_EXIST    if k == 'email'
        return ErrorEnum::MOBILE_EXIST   if k == 'mobile'
      end
    end
  
    self.update_attributes(opt)
    return self
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
