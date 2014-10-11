#encoding: utf-8
require 'rubygems'
require 'httparty'
require 'open-uri'
class SmsApi # 短信接口

  attr_reader :phone_number, :message

  include HTTParty

  base_uri 'http://yunpian.com/v1'

  APIKEY = "af6331b4c5873b9503f4c7fae15a2e6f"

  #同步发送即时短信
  def self.send_sms(type,tplid,phone,message)
    message.gsub!("\n", "")
    seqid = Random.rand(10000..9999999999999999).to_i

    result = post("/sms/tpl_send.json",
        :query => { :apikey => APIKEY,
            :mobile => phone,
            :tpl_id => tplid,
            :tpl_value => URI::encode(message),
            :uid => seqid },
        :headers => {"Accept" => "text/plain",'charset' => 'utf-8','Content-Type' => 'application/x-www-form-urlencoded'}
    )

    SmsHistory.create(mobile:phone,type:type,seqid:seqid,result:result)
    return result
  end



  ################### different types of sms ########################

  # 系统管理员添加企业管理员
  def self.admin_add_manager(type, mobile, opt)
    msg = "#mobile#=#{opt[:mobile]}&#pwd#=#{opt[:pwd]}"
    send_sms(type,497099,mobile,msg)
  end

  # 系统管理员添加查看员
  def self.admin_add_viewer(type,mobile,opt)
    msg = "#mobile#=#{opt[:mobile]}&#pwd#=#{opt[:pwd]}"
    send_sms(type,497251,mobile,msg)
  end

  # 系统管理员添加会员
  def self.admin_add_user(type,mobile,opt)
    msg = "#mobile#=#{opt[:mobile]}&#pwd#=#{opt[:pwd]}"
    send_sms(type,497267,mobile,msg)
  end

  # 企业管理员添加员工
  def self.manager_add_user(type,mobile,opt)
    msg = "#company#=#{opt[:company]}#&#mobile#=#{opt[:mobile]}&#pwd#=#{opt[:pwd]}"
    send_sms(type,497289,mobile,msg)    
  end

  #用户自己注册，短信通知对应的管理员
  # def self.user_regist(type,mobile,opt)
  #   msg = "#company=#{opt[:company]}#&#mobile#=#{opt[:mobile]}&#pwd#=#{opt[:pwd]}"
  #   send_sms(type,497289,mobile,msg)     
  # end


  #开课通知短信到学员
  def self.lesson_published_to_student(type,mlist,opt)
    msg = "#date#=#{opt[:date].strftime('%Y年%m月%d日')}#&#city#=#{opt[:city]}&#name#=#{opt[:name]}"
    mlist.each do |mobile|
      send_sms(type,497343,mobile,msg)
    end
  end

  # 开课通知短信到管理员
  def self.lesson_published_to_manager(type,mlist,opt)
    msg = "#date#=#{opt[:date].strftime('%Y年%m月%d日')}#&#city#=#{opt[:city]}&#name#=#{opt[:name]}"
    mlist.each do |mobile|
      send_sms(type,497343,mobile,msg)
    end
  end

  #课程取消短信
  def self.lesson_canceled_to_student(type,mobile,opt)
    # 原定#date#在#city#开课的#name#培训因故取消，您的报名也随之取消！
    course = Course.find(opt[:course_id])
    @start_date = course.start_date.strftime('%Y年%m月%d日')
    @city = course.show_city
    @lesson_name = course.name_en
    msg = "#date#=#{@start_date}#&#city#=#{@city}&#name#=#{@lesson_name}"
    send_sms(type,497381,mobile,msg)
  end

  #找回密码短信
  def self.find_password(type, mobile, opt)
    msg = "#pwd#={opt[:pwd]}"
    send_sms(type,497349,mobile,msg)
  end


  # 企业管理员审核拒绝短信
  def self.manager_refused_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @name = course.name_en
    msg = "#name#={@name}"
    send_sms(type,497387,mobile,msg)
  end



  # 学员自主创建的报名，短信通知企业管理员
  def self.user_create_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    user   = User.find(opt['user_id'])
    @uname = user.name
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/user_create_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)
  end

  #企业管理员取消无效的报名
  def self.manager_cancel_uneffective_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @manager = opt['manager']
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/manager_cancel_uneffective_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)    
  end

  #企业管理员取消有效的报名
  def self.manager_cancel_effective_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @manager = opt['manager']
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/manager_cancel_effective_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)       
  end

  # 用户自主取消有效报名，发短信通知对应的企业管理员
  def self.user_cancel_effective_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @user = opt['user']
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/user_cancel_effective_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)       
  end

  # 系统管理员删除无效的报名，发送短信到报名人
  def self.admin_cancel_uneffective_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/admin_cancel_uneffective_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)       
  end

  # 系统管理员取消无效的报名
  def self.admin_cancel_effective_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/admin_cancel_effective_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)     
  end

  #系统管理员审核报名通过
  def self.admin_allow_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @name  = course.name_en
    @date  = course.start_date.strftime('%F')
    text_template_file_name = "#{Rails.root}/app/views/sms_text/admin_allow_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)       
  end

  # 系统管理员拒绝报名
  def self.admin_refuse_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/admin_refuse_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    self.send_sms(type,mobile, text)      
  end

  # 系统管理员代理报名
  def self.admin_generate_order(type,mobile,opt)
    course = Course.find(opt['course_id'])
    @name  = course.name_en
    text_template_file_name = "#{Rails.root}/app/views/sms_text/admin_generate_order.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)    
  end

  # 课程时间发生变化
  def self.lesson_time_changed(type,mlist,opt)
    course = Course.find(opt[:course_id])
    #抱歉，TTT培训的开课日期变更为YYYY年MM月DD日！DynamicsReadiness.com
    @name = course.name_en
    @date = course.start_date.strftime('%F')
    text_template_file_name = "#{Rails.root}/app/views/sms_text/lesson_time_changed.text.erb"
    text_template = ERB.new(File.new(text_template_file_name).read, nil, "%")
    text = text_template.result(binding)
    group_size = 100
    groups = []
    while mlist.size >= group_size
      temp_group = mlist[0..group_size-1]
      groups << temp_group
      mlist = mlist[group_size..-1]
    end
    groups << mlist

    groups.each do |group|
      self.send_sms("massive_#{type}",group, text)
    end    
  end

  # 课前提醒短信，时间是由系统管理员确定的
  def self.lesson_pre_notice(type,mlist,opt)
  end

end
