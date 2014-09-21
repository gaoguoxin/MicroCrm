class Course
  include Mongoid::Document
  include Mongoid::Timestamps
  
  STATUS_CODE_0 = 0 #课程状态 未开始      
  STATUS_CODE_1 = 1 #课程状态 进行中
  STATUS_CODE_2 = 2 #课程状态 已结束
  STATUS_CODE_3 = 3 #课程状态 已取消

  TYPE_CODE_0   = 0 #现场
  TYPE_CODE_1   = 1 #在线

  LEVEL_CODE    = %w(困难 中等 容易)

  field :code,    type:String # 课程编码            
  field :name_cn, type:String # 中文名
  field :name_en, type:String # 英文名
  field :subject, type:String # 主题
  field :level,type:Integer #难易程度
  field :type, type:Integer,default:TYPE_CODE_0 # 课程类型
  field :receiver,type:String # 受众对象
  field :teacher,type:String   # 教师姓名
  field :teacher_avatar,type:String # 教师头像
  field :teacher_desc,type:String # 教师简介
  field :start_date,type:Date
  field :start_time,type:Time
  field :end_date,type:Date
  field :end_time,type:Time
  filed :during,type:String #课程持续时间,以天我为单位
  field :lim_num,type:Integer #最多容纳人数
  field :enroll_num,type:Integer #已经报名人数
  field :receive_num,type:Integer #已经接受人数
  field :real_num,type:Integer #实际参训人数
  field :description, type: String # 课程描述
  field :status,type:Integer,default:STATUS_CODE_0 # 课程状态
  field :city,type:String # 城市  
  field :address,type:String # 具体地址
  field :classroom,type:String # 课室

  has_many :orders
end
