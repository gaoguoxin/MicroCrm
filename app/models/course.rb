class Course
  include Mongoid::Document
  include Mongoid::Timestamps
  
  mount_uploader :instructor_avatar, AvatarUploader

  STATUS_CODE_0 = 0 #课程状态 规划中      
  STATUS_CODE_1 = 1 #课程状态 已发布
  STATUS_CODE_2 = 2 #课程状态 授课中
  STATUS_CODE_3 = 3 #课程状态 已交付
  STATUS_CODE_4 = 4 #课程状态 已取消

  STATUS_CODE_HASH = { 0 => '规划中',1 => '发布中',2 => '授课中',3 => '已交付',4 => '已取消'}

  TYPE_CODE_0   = 0 #现场
  TYPE_CODE_1   = 1 #在线

  TYPE_HASH     = {0 => '现场',1 => '在线'}

  LEVEL_CODE    = ['Level 100', 'Level 200', 'Level 300', 'Level 400']

  CHARGE_TYPE_0 = 0 # 收费 
  CHARGE_TYPE_1 = 1 #免费

  CHARGE_TYPE_HASH = {0 => '收费',1 => '免费'}
 
  CONTENT_TYPE_AX  = 'AX'
  CONTENT_TYPE_CRM = 'CRM'
  CONTENT_TYPE_AX_CRM = 'AX+CRM'
  CONTENT_TYPE_QT     = '其他'

  CONTENT_TYPE_ARRAY = %w(AX CRM AX+CRM 其他)

  CITY_ARRAY = %w(上海市 北京市 广州市 其他城市 在线)

  field :code,    type:String # 课程编码   limit 12 letter          
  field :name_cn, type:String # 中文名 limit 128 letter  
  field :name_en, type:String # 英文名 limit 128 letter 

  field :difficulty_level,type:String #难易程度 Level 100, Level 200, Level 300, Level 400
  field :delivery_type,type:Integer,default:TYPE_CODE_0 # 课程类型

  field :charge_category,type:Integer,default:CHARGE_TYPE_0 #收费


  field :content_type,type:String,default:CONTENT_TYPE_AX # 内容类型


  field :status,type:Integer,default:STATUS_CODE_0 #课程状态
  field :audience,type:String # 受众对象  limit 64 letter 
  field :instructor,type:String   # 教师姓名 limit 12 letter  
  field :instructor_avatar,type:String # 教师头像
  field :instructor_desc,type:String #教师简介 limit 1024 letter  
  field :start_date,type:Date
  field :start_time,type:String
  field :end_date,type:Date
  field :end_time,type:String
  field :duration,type:String #课程持续时间,以天我为单位
  field :lim_num,type:Integer #最多容纳人数
  field :description, type: String # 课程描述 2048 leter
  field :city,type:String # 城市  上海，北京，广州，其他城市，在线
  field :address,type:String # 具体地址
  field :classroom,type:String # 课室
  field :evaluation_general,type:Float,default:0.0 #课程总评分
  field :evaluation_instructor,type:Float,default:0.0 #讲师评分
  field :waiting_acctadmin_approval_num,type:Integer,default:0 #等待单位同意的人数
  field :waiting_sysadmin_approval_num,type:Integer,default:0 #单位已同意、等系统管理员接受的人数
  field :valid_registration_num,type:Integer,default:0 # 当前有效报名人数
  field :canceled_num,type:Integer,default:0 # 已取消报名的人数
  field :attendee_num,type:Integer,default:0 # 实际参训人数


  field :price_level1,type:Float # Managed伙伴价格
  field :price_level2,type:Float # Un-managed伙伴价格
  field :price_level3,type:Float # 公众价格

  field :manager_condition,type:String # 匹配短信通知管理员的条件  
  field :trainee_condition,type:String # 匹配短信通知学员的条件
  field :notice_content,type:String # 管理员自定义提醒短信内容
  field :notice_at,type:String #上课提醒短信提前多少天发送，可以指定很多个，元素代表提前多少天

  has_many :orders


  after_save :send_publish_msg

  def send_publish_msg
    if self.status_changed?
      if self.status == STATUS_CODE_1
        mlist = Company.where(pri_serv:/#{content_type}/).actived.map{|e| e.manager.mobile}
        slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.ax.map{|e| e.mobile} if self.trainee_condition == 'AX'
        slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.crm.map{|e| e.mobile} if self.trainee_condition == 'CRM'
        slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.ax.crm.map{|e| e.mobile} if self.trainee_condition == 'AX+CRM'
        slist = User.where(role_of_system:User::ROLE_EMPLOYEE).actived.qt.map{|e| e.mobile} if self.trainee_condition == '其他'
        #SmsWorker.perform_async("lesson_published_to_manager",mlist,{})
        #SmsWorker.perform_async("lesson_published_to_student",slist,{})
        self.notice_at.split(',').each do |d|
          send_time = (self.start_date - d).strftime('%Y%m%d100000') # 指定10点发送
          #SmsWorker.perform_async("lesson_published_specify_time",slist,{stime:send_time})  
        end
        
      end
    end
  end

  def show_content_type
    self.content_type
  end

  def show_city
    if self.delivery_type == TYPE_CODE_1
      return '无'
    else
      unless self.city.include?('其他城市')
        return self.address.split('市').first + '市'
      else
        return self.city
      end      
    end
  end

  def show_address
    if self.delivery_type == TYPE_CODE_0
      unless self.city.include?('其他城市')
        self.city + ' ' + self.address + ' ' + self.classroom
      else
        self.address + ' ' + self.classroom
      end
    else
      self.address || '在线课程'
    end
  end

  def self.search(opt)
    self.where(status:opt[:status])
  end


end
