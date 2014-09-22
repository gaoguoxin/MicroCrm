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

  field :name, type: String
  field :email, type: String
  field :mobile, type: String
  field :password, type: String
  field :role, type: Integer,:default => 3
  field :position, type: String
  field :related, type:Integer #表示该用户主要关联的产品
  field :course_count,type:Integer #该用户有效报名的人天总数
  field :description,type:String #该用户对自己的描述
  field :qq, type: String
  field :wechart, type: String
  field :skype, type: String
  field :gtalk, type: String
  field :twitter, type: String
  field :facebook, type: String


  belongs_to :company

  #注册用户
  def self.regist(opt)
    account = {}
    account[:name]    = opt[:name]
    account[:email]   = opt[:email].to_s.downcase
    account[:mobile]  = opt[:mobile]
    account[:role]    = opt[:role] || ROLE_EMPLOYEE
    opt[:password]    = opt[:password].downcase
    return ErrorEnum::NAME_BLANK unless account[:name].present?
    return ErrorEnum::EMAIL_BLANK unless account[:email].present?
    return ErrorEnum::MIBILE_BLANK unless account[:mobile].present?
    return ErrorEnum::PASSWORD_BLANK unless opt[:password].present?

    account[:password] = make_encrypt(opt[:password])

    exist_user = false

    user = self.find_by_email(account[:email])
    user = self.find_by_mobile(account[:mobile]) unless user.present?

    exist_user = true if user.present?
    return ErrorEnum::USER_EXIST if exist_user

    user = self.create(account)
    
    # if account[:source] == SOURCE_S #系统管理员添加企业管理员行为
    #   # if user.mobile.present?
    #   #   SmsWorker.perform_async("add_manager",user.mobile,opt[:password])
    #   # end
    # elsif account[:source] == SOURCE_M #企业管理员添加员工行为
    #   # if user.mobile.present?
    #   #   SmsWorker.perform_async("add_employee",user.mobile,opt[:password])
    #   # end
    # end

    return user
  end

  #登录用户
  def self.login(opt)
    email_mobile =  opt[:email_mobile].to_s.downcase
    password     =  opt[:password].downcase
    user = self.find_by_email_or_mobile(email_mobile)
    return ErrorEnum::USER_NOT_EXIST unless user.present?
    return ErrorEnum::PASSWORD_ERROR if user.password != make_encrypt(password)
    user.write_attribute(:ref,'/admin/courses') if user.is_system? || user.is_viewer?
    user.write_attribute(:ref,'/manager/users') if user.is_manager?
    user.write_attribute(:ref,'/user/users') if user.is_employee?
    return user
  end

  def self.check_exist(opt)
    email  = opt[:email].to_s.downcase
    mobile = opt[:mobile].to_s.downcase
    if email.present?
      user = self.find_by_email(email)  
    else
      user = self.find_by_mobile(mobile) 
    end
    return user
  end


  def self.update_pwd(user,opt)
    password = opt[:password].downcase
    password = make_encrypt(password)
    user.update_attributes(password:password)
    return user
  end


  def update_info(opt)
    opt.each_pair do |k,v|
      k = v.downcase.strip!
      user = User.find_by_col("#{k}",v,self.id.to_s)
      if user.present?
        return ErrorEnum::EMAIL_EXIST    if k == 'email'
        return ErrorEnum::MOBILE_EXIST   if k == 'mobile'
        return ErrorEnum::QQ_EXIST       if k == 'qq'
        return ErrorEnum::WECHART_EXIST  if k == 'wechart'
        return ErrorEnum::SKYPE_EXIST    if k == 'skype'
        return ErrorEnum::GTALK_EXIST    if k == 'gtalk'
        return ErrorEnum::TWITTER_EXIST  if k == 'twitter'
        return ErrorEnum::FACEBOOK_EXIST if k == 'facebook'
      end
    end
  
    self.update_attributes(opt)
    return self
  end

  def is_admin?
    return self.role == ROLE_ADMIN
  end

  def is_viewer?
    return self.role == ROLE_VIEW
  end

  def is_manager?
    return self.role == ROLE_MANAGER
  end

  def is_employee?
    return self.role == ROLE_EMPLOYEE
  end


  private 

  def self.make_encrypt(password)
    password = Encryption.encrypt_password(password)
  end

end
