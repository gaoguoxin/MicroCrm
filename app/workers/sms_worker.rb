class SmsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10, :queue => "microcrm_#{Rails.env}".to_sym

  def perform(sms_type, mobile,opt={})
    case sms_type
    when 'admin_add_manager'
      puts '----in admin add manager action ----------'
      retval = SmsApi.admin_add_manager_sms(sms_type, mobile, opt)
    when 'admin_add_viewer'
      puts '----in admin add viewer action ----------'
      retval = SmsApi.admin_add_viewer_sms(sms_type, mobile, opt)
    when 'admin_add_user'
      puts '----in admin add user action ----------'
      retval = SmsApi.admin_add_user_sms(sms_type, mobile, opt)        
    when 'manager_add_user'
      puts '----in manager add user action ----------'
      retval = SmsApi.manager_add_user_sms(sms_type, mobile, opt)
    when 'user_regist'
      Rails.logger.info('----in user regist action ----------') 
      retval = SmsApi.user_regist_sms(sms_type, mobile, opt)
    when 'lesson_published_to_student'
      retval = SmsApi.lesson_published_to_student(sms_type, mobile, opt)
    when 'lesson_published_to_manager'
      retval = SmsApi.lesson_published_to_manager(sms_type, mobile, opt)
    when 'lesson_published_specify_time'
      retval = SmsApi.lesson_published_specify_time(sms_type, mobile, opt)
    when 'lesson_canceled_to_student'
      retval = SmsApi.lesson_canceled_to_student(sms_type, mobile, opt)
    when 'find_password'
      retval = SmsApi.find_password(sms_type, mobile, opt)
    when 'manager_refused_order'
      retval = SmsApi.manager_refused_order(sms_type, mobile, opt)
    when 'user_create_order'
      retval = SmsApi.user_create_order(sms_type, mobile, opt)
    when 'manager_cancel_uneffective_order'
      retval = SmsApi.manager_cancel_uneffective_order(sms_type, mobile, opt)
    when 'manager_cancel_effective_order'
      retval = SmsApi.manager_cancel_effective_order(sms_type, mobile, opt)
    when 'user_cancel_effective_order'
      retval = SmsApi.user_cancel_effective_order(sms_type, mobile, opt)
    when 'admin_cancel_uneffective_order'
      retval = SmsApi.admin_cancel_uneffective_order(sms_type, mobile, opt)  
    when 'admin_cancel_effective_order'
      retval = SmsApi.admin_cancel_effective_order(sms_type, mobile, opt)  
    when 'admin_allow_order'
      retval = SmsApi.admin_allow_order(sms_type, mobile, opt)
    when 'admin_refuse_order'  
      retval = SmsApi.admin_refuse_order(sms_type, mobile, opt)
    end
    return true
  end
end
