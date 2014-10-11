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
  field :enroll_count,type:Float,default:0.0 #有效报名人天数
  field :description,type:String #描述

  has_many :users
  has_many :cards
  belongs_to :manager, class_name: "User", inverse_of: :company

  before_save :convert_name

  scope :actived, -> { where(status: STATUS_GOING) }
  scope :except_other, ->{where(:name.ne => '其他')}
  
  def self.create_new(opt,creater)
    opt = create_manager(opt,creater)
    return true
  end

  def self.create_manager(opt,creater)
    user = User.find_by_email(opt[:manager_id]) if opt[:manager_id].to_s.downcase.match(/#{User::EmailRexg}/i)
    user = User.find_by_mobile(opt[:manager_id]) unless user.present?

    unless user.present? # 用户不存在的时候可以创建一个,并设置为该企业的管理员
      if !opt[:name].include?('其他')
        # “其他” 这个特殊的公司不给创建管理员
        account = {}
        account[:name]               =  '企业管理员'#opt[:manager_id].split('@').first #企业管理员的名字默认为手机号或者邮箱的前部分
        account[:email]              =  opt[:manager_id].to_s.downcase  if opt[:manager_id].to_s.downcase.match(/#{User::EmailRexg}/i)
        account[:mobile]             =  opt[:manager_id].to_s.downcase  if opt[:manager_id].to_s.downcase.match(/#{User::MobileRexg}/i)
        account[:role_of_system]     =  User::ROLE_MANAGER
        account[:password]           =  '111111' #创建公司时创建的企业管理员，密码6个1
        user = User.regist(account,true,false,creater)
      else
        user = User.where(role_of_system:User::ROLE_ADMIN).first  #其他这个企业的管理员是系统管理员
      end
    end

    company = self.create(opt)
    user.companies << company
    user.update_attributes(company_id:company.try(:id).to_s)
  end

  def self.update_info(opt,inst,creater)
    user = User.find_by_email(opt[:manager_id]) if opt[:manager_id].to_s.downcase.match(/#{User::EmailRexg}/i)
    user = User.find_by_mobile(opt[:manager_id]) unless user.present?

    unless user.present? # 用户不存在的时候可以创建一个,并设置为该企业的管理员
      account = {}
      account[:name]               =  '企业管理员'#opt[:manager_id].split('@').first #企业管理员的名字默认为手机号或者邮箱的前部分
      account[:email]              =  opt[:manager_id].to_s.downcase  if opt[:manager_id].to_s.downcase.match(/#{User::EmailRexg}/i)
      account[:mobile]             =  opt[:manager_id].to_s.downcase  if opt[:manager_id].to_s.downcase.match(/#{User::MobileRexg}/i)
      account[:role_of_system]     =  User::ROLE_MANAGER
      account[:password]           =  '111111' #创建公司时创建的企业管理员，密码6个1
      user = User.regist(account,true,false,creater)
    end
    inst.manager.update_attributes(role_of_system:User::ROLE_EMPLOYEE)
    user.update_attributes(role_of_system:User::ROLE_MANAGER,company_id:inst.id.to_s)
    opt[:manager_id] = user.id.to_s
    inst.update(opt)
    return true
  end

  #系统管理员搜索
  def self.search(opt)      
    result = self.all
    if opt['search_account'].present?
      manager = User.where(role_of_system:User::ROLE_MANAGER,email: opt['search_account'].downcase.strip!).first
      manager = User.where(role_of_system:User::ROLE_MANAGER,mobile: opt['search_account'].downcase.strip!).first unless manager.present?
      if manager.present?
        result = manager.companies || []
      else
        result = []
      end
      return result
    end 

    if opt['search_start'].present?
      result = result.where(:created_at.gte => DateTime.parse(opt['search_start']))
    end
    if opt['search_end'].present?
      result = result.where(:created_at.lte => DateTime.parse(opt['search_end']))
    end
    if opt['search_status'].present?
      result = result.where(:status => opt['search_status'].to_i)
    end
    if opt['search_type'].present?
      result = result.where(:type => opt['search_type'].to_i)
    end    
    if opt['search_level'].present?
      result = result.where(:level => opt['search_level'].to_s)
    end           
    if opt['search_name'].present?    
      result = result.where(name: /#{opt['search_name'].to_s.downcase}/)
    end 
    return result    
  end

  def self.match_course_manager(content_type)
    self.where(pri_serv:/#{content_type}/).actived.count
  end

  def convert_name
    self.name = self.name.downcase
  end

end
