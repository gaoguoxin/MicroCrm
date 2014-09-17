require 'encryption'
require 'error_enum'
require 'find_tool'
class User
  include Mongoid::Document
  include FindTool
  include Mongoid::Timestamps

  EmailRexg  = '\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z'
  MobileRexg = '^(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$' 

  ROLE_ADMIN = 1 # 系统管理员   
  ROLE_MANAGER = 2 # 企业管理员
  ROLE_EMPLOYEE = 3 # 普通用户
 
  STATUS_UN_COMPLETE = 0 # 尚未完成个人信息
  STATUS_COMPLETE = 1 # 已经完成个人信息

  MALE = 0 #男
  FEMALE = 1 # 女

  SOURCE_R = 0 #注册用户
  SOURCE_M = 1 #管理员添加用户
  SOURCE_S = 2 #系统管理员添加用户

  field :name, type: String
  field :email, type: String
  field :mobile, type: String
  field :password, type: String
  field :age, type: Integer
  field :sex, type: Integer
  field :role, type: Integer,:default => 3
  field :status, type: Integer,:default => 0
  field :source, type: Integer,:default => 0 

  belongs_to :company
  belongs_to :position

  #注册用户
  def self.regist(opt)
    account = {}
    email_mobile      = opt[:email_mobile].to_s.downcase
    account[:role]    = opt[:role] || ROLE_EMPLOYEE
    account[:source]  = opt[:source] ||  SOURCE_R
    opt[:password]    = opt[:password].downcase

    return ErrorEnum::EMAIL_MIBILE_BLANK unless email_mobile.present?
    return ErrorEnum::PASSWORD_BLANK unless opt[:password].present?

    account[:password] = make_encrypt(opt[:password])

    exist_user = false

    user = self.find_by_email_or_mobile(email_mobile)

    exist_user = true if user.present?
    return ErrorEnum::USER_EXIST if exist_user

    if email_mobile.match(/#{EmailRexg}/i)
      account[:email] = email_mobile
    elsif email_mobile.match(/#{MobileRexg}/i)
      account[:mobile] = email_mobile
    end

    user = self.create(account)
    
    if account[:source] == SOURCE_S #系统管理员添加企业管理员行为
      # if user.mobile.present?
      #   SmsWorker.perform_async("add_manager",user.mobile,opt[:password])
      # end
    elsif account[:source] == SOURCE_M #企业管理员添加员工行为
      # if user.mobile.present?
      #   SmsWorker.perform_async("add_employee",user.mobile,opt[:password])
      # end
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
    return user
  end

  def self.check_exist(opt)
    user = self.find_by_email_or_mobile(opt[:email_mobile])
  end

  # 更改信息
  def update_info(opt)
    self.update(opt)
    if self.company.present? && company.name != '其他'
      if opt[:company_id].present?  #用户如果之前填写了公司信息，那么不允许用户再次修改所属公司信息
        SmsWorker.perform_async("join_company",self.company.mobile,self)
      end
    end
    return self
  end



  private 

  def self.make_encrypt(password)
    password = Encryption.encrypt_password(password)
  end

end
