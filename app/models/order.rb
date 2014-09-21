class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  
  SOURCE_CODE_0 = 0 #报名记录产生自学员自主报名
  SOURCE_CODE_1 = 1 #报名记录产生自企业管理员代报名
  SOURCE_CODE_2 = 2 #报名记录产生自系统管理员代报名

  STATUS_CODE_0 = 0 #企业管理员审核状态  待审核
  STATUS_CODE_1 = 1 #企业管理员审核状态  审核通过
  STATUS_CODE_2 = 2 #企业管理员审核状态  审核拒绝

  STATE_CODE_0  = 0 #系统管理员审核状态值 待审核
  STATE_CODE_1  = 1 #系统管理员审核状态值 审核通过
  STATE_CODE_2  = 2 #系统管理员审核状态值 审核拒绝

  CANCEL_CODE_0 = 0 #谁取消的报名  学员
  CANCEL_CODE_1 = 1 #谁取消的报名  企业管理员
  CANCEL_CODE_2 = 2 #谁取消的报名  系统管理员

  field :source, type: Inteter,default: SOURCE_CODE_0 # 报名记录产生的来源
  field :status, type: Integer,default: SOURCE_CODE_0 # 企业管理员审核状态  
  field :status_at,type:Array  # 企业管理员审核发生的时间，可能多次改变status值
  field :state, type: Integer,default: STATE_CODE_0  #系统管理员审核状态值
  field :state_at,type:Array #系统管理员审核发生的时间，可能多次改变state值
  field :is_cancel,type:Boolean,default: false #该报名是否已经取消
  field :cancel_type, type:Integer #谁取消的报名
  field :cancel_at,type:DateTime # 取消报名的时间
  field :presence,type: Float #出勤的概率


  has_many :users
  belongs_to :course
end
