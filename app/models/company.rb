class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  STATUS_FINISHED  = 0 #合作已终止  
  STATUS_GOING     = 1 #合作进行中

  COMP_TYPE_1      = 1 #伙伴
  COMP_TYPE_2      = 2 #客户
  COMP_TYPE_3      = 3 #管理单位

  COMP_TYPE_HASH = {1 => '伙伴', 2 => '客户',3 => '管理单位'}        

  field :name, type: String
  field :status, type: Integer,default:STATUS_GOING # 合作状态 
  field :type, type: Integer # 合作类型  伙伴 客户 管理单位
  field :level,type: String #等级
  field :pri_serv,type:String #主要业务
  field :main_area,type:String #主要区域
  field :sale_count,type:Integer # 销售人员数量
  field :ax_count,type:Integer #AX售前人员数量
  field :crm_count,type:Integer #CRM售前人员数量
  field :ax_adviser_count,type:Integer #AX顾问数量
  field :crm_adviser_count,type:Integer #crm顾问数量
  field :dynamic_count,type:Integer #Dynamics从业人员数量
  field :enroll_count,type:Integer #有效报名人天数
  field :description,type:String #描述

  has_many :users
  belongs_to :manager, class_name: "User", inverse_of: :company

  scope :actived, -> { where(status: STATUS_GOING) }


  def cooperate
    COMP_TYPE_HASH[self.type]
  end

end
