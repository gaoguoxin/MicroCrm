class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_CODE_0 = 0 #课程状态 规划中      
  STATUS_CODE_1 = 1 #课程状态 已发布
  STATUS_CODE_2 = 2 #课程状态 授课中
  STATUS_CODE_3 = 3 #课程状态 已交付
  STATUS_CODE_4 = 4 #课程状态 已取消

  TYPE_CODE_0   = 0 #现场
  TYPE_CODE_1   = 1 #在线

  LEVEL_CODE    = %w(困难 中等 容易)

  CHARGE_TYPE_0 = 0 # 收费 
  CHARGE_TYPE_1 = 1 #免费
 
  CONTENT_TYPE_AX  = 'AX'
  CONTENT_TYPE_CRM = 'CRM'
  CONTENT_TYPE_AX_CRM = 'AX+CRM'


  field :code,    type:String # 课程编码   limit 12 letter          
  field :name_cn, type:String # 中文名 limit 128 letter  
  field :name_en, type:String # 英文名 limit 128 letter  
  field :difficulty_level,type:String #难易程度 Level 100, Level 200, Level 300, Level 400
  field :delivery_type,type:Integer,default:TYPE_CODE_0 # 课程类型
  field :charge_category,type:Integer,default:CHARGE_TYPE_0 #收费
  field :content_type,type:Integer,default:CONTENT_TYPE_AX # 内容类型
  field :status,type:Integer,default:STATUS_CODE_0 #课程状态
  field :audience,type:String # 受众对象  limit 64 letter 
  field :instructor,type:String   # 教师姓名 limit 12 letter  
  field :instructor_avatar,type:String # 教师头像
  field :instructor_desc,type:String #教师简介 limit 1024 letter  
  field :start_date,type:Date
  field :start_time,type:Time
  field :end_date,type:Date
  field :end_time,type:Time
  field :duration,type:String #课程持续时间,以天我为单位
  field :lim_num,type:Integer #最多容纳人数
  field :description, type: String # 课程描述 2048 leter
  field :city,type:String # 城市  上海，北京，广州，其他城市，在线
  field :address,type:String # 具体地址
  field :classroom,type:String # 课室
  field :evaluation_general,type:Float #课程总评分
  field :evaluation_instructor,type:Float #讲师评分
  field :waiting_acctadmin_approval_num,type:Integer #等待单位同意的人数
  field :waiting_sysadmin_approval_num,type:Integer #单位已同意、等系统管理员接受的人数
  field :valid_registration_num,type:Integer # 当前有效报名人数
  field :canceled_num,type:Integer # 已取消报名的人数
  field :attendee_num,type:Integer # 实际参训人数
  field :price_level1,type:Float # Managed伙伴价格
  field :price_level2,type:Float # Un-managed伙伴价格
  field :price_level3,type:Float # 公众价格

  has_many :orders
end
