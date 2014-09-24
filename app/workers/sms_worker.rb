class SmsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10, :queue => "microsoft_crm_#{Rails.env}".to_sym

  def perform(sms_type, mobile,opt={})
    case sms_type
    when 'admin_add_manager'
      puts '----in admin add manager action ----------'
      #retval = SmsApi.admin_add_manager_sms(sms_type, mobile, opt)
    when 'admin_add_viewer'
      puts '----in admin add viewer action ----------'
      #retval = SmsApi.admin_add_viewer_sms(sms_type, mobile, opt)
    when 'admin_add_user'
      puts '----in admin add user action ----------'
      #retval = SmsApi.admin_add_user_sms(sms_type, mobile, opt)        
    when 'manager_add_user'
      puts '----in manager add user action ----------'
      #retval = SmsApi.manager_add_user_sms(sms_type, mobile, opt)
    when 'user_regist'
      puts '----in user regist action ----------'
      #retval = SmsApi.user_regist_sms(sms_type, mobile, opt)
    end
    return true
  end
end
