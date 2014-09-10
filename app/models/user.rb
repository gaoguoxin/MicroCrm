require 'encryption'
require 'error_enum'
require 'find_tool'
class User
  include Mongoid::Document
  include FindTool
  include Mongoid::Timestamps
  
 
  EmailRexg  = '\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z'
  MobileRexg = '^(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$' 

  ADMIN = 1 # 系统管理员   
  MANAGER = 2 # 企业管理员
  EMPLOYEE = 3 # 普通用户
 
  UN_COMPLETE = 0 # 尚未完成个人信息
  OK_COMPLETE = 1 # 已经完成个人信息

  field :name, type: String
  field :email, type: String
  field :mobile, type: String
  field :pasword, type: String
  field :role, type: Integer
  field :status, type:Integer

  belongs_to :company



  def self.create_new_user(opt)  
    account = {}
    if opt[:email].match(/#{EmailRexg}/i)  ## match email
      account[:email] = opt[:email].downcase
    end

    return ErrorEnum::ILLEGAL_EMAIL_OR_MOBILE if account.blank?
    existing_user = account[:email] ? self.find_by_email(account[:email]) : self.find_by_mobile(account[:mobile])
    return ErrorEnum::USER_REGISTERED if existing_user
    existing_user = User.create if existing_user.nil?
    password = Encryption.encrypt_password(opt[:password]) if account[:email]
    account[:status] =  UN_COMPLETE

    updated_attr = account.merge(password: password)

    existing_user.update_attributes(updated_attr)

    return existing_user
  end


end
