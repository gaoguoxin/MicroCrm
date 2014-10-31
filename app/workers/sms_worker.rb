class SmsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10, :queue => "microcrm_#{Rails.env}".to_sym

  def perform(sms_type, mobile,opt={})
    case sms_type
    when 'lesson_address_changed'
      retval = SmsApi.lesson_address_changed(sms_type, mobile, opt)
    when 'lesson_time_changed'
      retval = SmsApi.lesson_time_changed(sms_type, mobile, opt)
    when 'lesson_published_to_manager'
      retval = UserMailer.publish_lesson_to_manager(mobile, opt).deliver
    when 'lesson_published_to_student'
      retval = UserMailer.publish_lesson(mobile, opt).deliver
    when 'lesson_canceled_to_student'
      retval = SmsApi.lesson_canceled_to_student(sms_type, mobile, opt)
    when 'lesson_pre_notice'
      retval = SmsApi.lesson_pre_notice(sms_type, mobile, opt) 
    when 'user_create_order'
      retval = SmsApi.user_create_order(sms_type, mobile, opt)
    when 'manager_cancel_uneffective_order'
      retval = SmsApi.manager_cancel_uneffective_order(sms_type, mobile, opt)
    when 'manager_cancel_effective_order'
      retval = SmsApi.manager_cancel_effective_order(sms_type, mobile, opt)
    when 'manager_refused_order'
      retval = SmsApi.manager_refused_order(sms_type, mobile, opt)
    when 'user_cancel_effective_order'
      retval = SmsApi.user_cancel_effective_order(sms_type, mobile, opt)
    when 'admin_cancel_effective_order'
      retval = SmsApi.admin_cancel_effective_order(sms_type, mobile, opt)
    when 'admin_cancel_uneffective_order'
      retval = SmsApi.admin_cancel_uneffective_order(sms_type, mobile, opt)  
    when 'admin_generate_order'
      retval = SmsApi.admin_generate_order(sms_type, mobile, opt)
    when 'admin_allow_order'
      retval = SmsApi.admin_allow_order(sms_type, mobile, opt)
    when 'admin_refuse_order'  
      retval = SmsApi.admin_refuse_order(sms_type, mobile, opt)
    when 'admin_add_manager'
      retval = SmsApi.admin_add_manager(sms_type, mobile, opt)
    when 'admin_add_viewer'
      retval = SmsApi.admin_add_viewer(sms_type, mobile, opt)
    when 'admin_add_user'
      retval = SmsApi.admin_add_user(sms_type, mobile, opt)  
    when 'manager_add_user'
      retval = SmsApi.manager_add_user(sms_type, mobile, opt)
    when 'user_regist'
      retval = SmsApi.user_regist(sms_type, mobile, opt)
    when 'find_password'
      retval = SmsApi.find_password(sms_type, mobile, opt)
    end
    return true
  end
end
