class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  STATUS_FINISHED  = 0 #合作已终止  
  STATUS_GOING     = 1 #合作进行中
  STATUS_HASH      = {1 => '合作进行中',0 => '合作已终止'}

  COMP_TYPE_1      = 1 #伙伴
  COMP_TYPE_2      = 2 #客户
  COMP_TYPE_3      = 3 #管理单位
  TYPE_HASH        = {1 => '伙伴', 2 => '客户',3 => '管理单位'}

  LEVEL_ARRAY      = %w(GSI  Mngd Accelarate Other)

  field :name, type: String
  field :status, type: Integer,default:STATUS_GOING # 合作状态 
  field :type, type: Integer # 合作类型  伙伴 客户 管理单位
  field :level,type: String #等级
  field :pri_serv,type:String #主要业务
  field :main_area,type:String #主要区域
  field :sales_count,type:Integer # 销售人员数量
  field :ax_presales_count,type:Integer #AX售前人员数量
  field :crm_presales_count,type:Integer #CRM售前人员数量
  field :ax_consultant_count,type:Integer #AX顾问数量
  field :crm_consultant_count,type:Integer #crm顾问数量
  field :dynamic_count,type:Integer #Dynamics从业人员数量
  field :enroll_count,type:Integer,default:0 #有效报名人天数
  field :description,type:String #描述

  has_many :users
  belongs_to :manager, class_name: "User", inverse_of: :company

  scope :actived, -> { where(status: STATUS_GOING) }
  def self.create_new(opt)
    opt = create_manager(opt)
    self.create(opt)
    return true
  end

  def self.create_manager(opt)
    user = User.find_by_email(opt[:manager_id]) if opt[:manager_id].to_s.downcase.match(/#{User::EmailRexg}/i)
    user = User.find_by_mobile(opt[:manager_id]) unless user.present?
    unless user.present? # 用户不存在的时候可以创建一个,并设置为该企业的管理员
      if opt[:manager_id].present? && !opt[:name].include?('其他')
        # “其他” 这个特殊的公司不给创建管理员
        account = {}
        account[:name]               =  opt[:manager_id].split('@').first #企业管理员的名字默认为手机号或者邮箱的前部分
        account[:email]              =  opt[:manager_id].to_s.downcase  if opt[:manager_id].to_s.downcase.match(/#{User::EmailRexg}/i)
        account[:mobile]             =  opt[:manager_id].to_s.downcase  if opt[:manager_id].to_s.downcase.match(/#{User::MobileRexg}/i)
        account[:role_of_system]     =  User::ROLE_MANAGER
        account[:password]           =  '111111' #创建公司时创建的企业管理员，密码6个1
        user = User.regist(account,true)
      end
    end
    opt[:manager_id] = user.id.to_s
    return opt    
  end

  def self.update_info(opt,inst)
    opt = create_manager(opt)
    inst.update(opt)
    return true
  end

end
