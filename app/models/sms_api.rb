#encoding: utf-8
require 'rubygems'
require 'httparty'
require 'open-uri'
class SmsApi # 短信接口
  ChinaSMS.use :yunpian, password: 'af6331b4c5873b9503f4c7fae15a2e6f'

  #同步发送即时短信
  def self.send_sms(type,tplid,phone,tpl_params)
    return false unless Rails.env == 'production'
    result = ChinaSMS.to "#{phone}", tpl_params, tpl_id: tplid
    SmsHistory.create(mobile:phone,type:type,result:result)
  end

  ################### different types of sms ########################

  #课程地址变更通知短信
  def self.lesson_address_changed(type, mlist, opt)
    course    = Course.find(opt[:course_id])
    date      = course.start_date.strftime('%F')
    name      = course.name_cn 
    address   = course.address + course.classroom
    tpl_value = { date:"#{date}", name:"#{name}", address:"#{address}"}

    mlist.each do |mobile|
      send_sms(type,499435,mobile,tpl_value)
    end
  end

  #课程时间变更短信
  def self.lesson_time_changed(type, mlist, opt)
    course    = Course.find(opt[:course_id])
    date      = course.start_date.strftime('%F') + ' ' + cousre.start_time
    name      = course.name_cn 
    tpl_value = { name:"#{name}", date:"#{date}"}

    mlist.each do |mobile|
      send_sms(type,499447,mobile,tpl_value)
    end     
  end

  # 开课通知短信到管理员
  def self.lesson_published_to_manager(type,mlist,opt)
    course     = Course.find(opt[:course_id])
    type       = course.trainee_condition
    name       = course.name_cn
    date       = course.start_date.strftime('%F')
    city       = course.show_city
    tpl_value  = { type:"#{type}", name:"#{name}", date:"#{date}", city:"#{city}"}

    mlist.each do |mobile|
      send_sms(type,497343,mobile,tpl_value)
    end
  end  

  #开课通知短信到学员
  def self.lesson_published_to_student(type,mlist,opt)
    course     = Course.find(opt[:course_id])
    type       = course.trainee_condition
    name       = course.name_cn
    date       = course.start_date.strftime('%F')
    city       = course.show_city
    tpl_value  = { type:"#{type}", name:"#{name}", date:"#{date}", city:"#{city}"}

    mlist.each do |mobile|
      send_sms(type,497343,mobile,tpl_value)
    end
  end

  #课程取消短信
  def self.lesson_canceled_to_student(type,mobile,opt)
    course       = Course.find(opt[:course_id])
    date         = course.start_date.strftime('%Y年%m月%d日')
    city         = course.show_city
    name         = course.name_cn
    tpl_value    = { date:"#{date}", city:"#{city}", name:"#{name}"}

    send_sms(type,497381,mobile,tpl_value)
  end

  # 课前提醒短信，时间是由系统管理员确定的
  def self.lesson_pre_notice(type,mlist,opt)
    course       = Course.find(opt[:course_id])
    date         = course.start_date.strftime('%Y年%m月%d日')
    city         = course.show_city
    name         = course.name_cn
    tpl_value    = { name:"#{name}", date:"#{date}", city:"#{city}"}

    mlist.each do |mobile|
      send_sms(type,499519,mobile,tpl_value)
    end    
  end

  # 学员自主创建的报名，短信通知企业管理员
  def self.user_create_order(type,mobile,opt)
    course       = Course.find(opt[:course_id])
    user         = User.find(opt[:user_id])
    uname        = user.name
    name         = course.name_cn
    tpl_value    = "uname#=#{uname}#name#=#{name}"
    tpl_value    = { uname:"#{uname}", name:"#{name}"}

    send_sms(type,499535,mobile,tpl_value)
  end

  #企业管理员取消无效的报名
  def self.manager_cancel_uneffective_order(type,mobile,opt)
    course    = Course.find(opt[:course_id])
    manager   = opt['manager']
    name      = course.name_cn
    tpl_value = { name:"#{name}", manager:"#{manager}"}

    send_sms(type,499543,mobile,tpl_value)
  end

  #企业管理员取消有效的报名
  def self.manager_cancel_effective_order(type,mobile,opt)
    course    = Course.find(opt[:course_i])
    manager   = opt['manager']
    name      = course.name_cn
    tpl_value = { name:"#{name}", manager:"#{manager}"}

    send_sms(type,499565,mobile,tpl_value)      
  end

  # 企业管理员审核拒绝短信
  def self.manager_refused_order(type,mobile,opt)
    course    = Course.find(opt[:course_id])
    name      = course.name_cn
    manager   = opt[:manager]
    tpl_value = { manager:"#{manager}", name:"#{name}"}

    send_sms(type,499573,mobile,tpl_value)
  end

  # 用户自主取消有效报名，发短信通知对应的企业管理员
  def self.user_cancel_effective_order(type,mobile,opt)
    course    = Course.find(opt['course_id'])
    user      = opt['user']
    name      = course.name_cn
    tpl_value = { uname:"#{user}", name:"#{name}"}

    send_sms(type,499605,mobile,tpl_value)
  end

  # 系统管理员取消有效的报名
  def self.admin_cancel_effective_order(type,mobile,opt)
    course    = Course.find(opt['course_id'])
    name      = course.name_cn
    tpl_value = { name:"#{name}"}

    send_sms(type,499599,mobile,tpl_value)
  end

  # 系统管理员删除无效的报名，发送短信到报名人
  def self.admin_cancel_uneffective_order(type,mobile,opt)
    course    = Course.find(opt['course_id'])
    name      = course.name_cn
    tpl_value = { name:"#{name}"}

    send_sms(type,499609,mobile,tpl_value)
  end

  # 系统管理员代理报名
  def self.admin_generate_order(type,mobile,opt)
    course    = Course.find(opt['course_id'])
    name      = course.name_cn
    tpl_value = { name:"#{name}"}

    send_sms(type,499623,mobile,tpl_value) 
  end

  #系统管理员审核报名通过
  def self.admin_allow_order(type,mobile,opt)
    course    = Course.find(opt['course_id'])
    name      = course.name_cn
    date      = course.start_date.strftime('%F')
    tpl_value = { name:"#{name}", date:"#{date}",city:"#{city}"}

    send_sms(type,499629,mobile,tpl_value)
  end

  # 系统管理员拒绝报名
  def self.admin_refuse_order(type,mobile,opt)
    course    = Course.find(opt['course_id'])
    name      = course.name_cn
    tpl_value = { name:"#{name}"}
    send_sms(type,499637,mobile,tpl_value)  
  end
  # 系统管理员添加企业管理员
  def self.admin_add_manager(type, mobile, opt)
    tpl_value = { mobile:"#{opt[:mobile]}",pwd:"#{opt[:pwd]}"}
    send_sms(type,499761,mobile,tpl_value)
  end

  # 系统管理员添加查看员
  def self.admin_add_viewer(type,mobile,opt)
    tpl_value = { mobile:"#{opt[:mobile]}",pwd:"#{opt[:pwd]}"}
    send_sms(type,499763,mobile,tpl_value)
  end

  # 系统管理员添加会员
  def self.admin_add_user(type,mobile,opt)
    tpl_value = { mobile:"#{mobile}",pwd:"#{opt['pwd']}"}
    send_sms(type,499765,mobile,tpl_value)
  end

  # 企业管理员添加员工
  def self.manager_add_user(type,mobile,opt)
    tpl_value = { company:"#{opt['company']}",mobile:"#{opt['mobile']}",pwd:"#{opt['pwd']}"}
    send_sms(type,497289,mobile,tpl_value)    
  end

  #用户自己注册，短信通知对应的管理员
  def self.user_regist(type,mobile,opt)
    tpl_value = { name:"#{opt['name']}"}
    send_sms(type,499769,mobile,tpl_value)     
  end

  #找回密码短信
  def self.find_password(type, mobile, opt)
    tpl_value = { pwd:"#{opt['pwd']}"}
    send_sms(type,499773,mobile,tpl_value)
  end

end
