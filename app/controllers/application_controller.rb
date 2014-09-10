class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def render_json_e(error_code)
    error_code_obj = {
      :error_code => error_code,
      :error_message => ""
    }
    render_json false do 
      error_code_obj
    end
  end


  def render_json_s(value = true, options={})
    render_json true do 
      value
    end
  end


  def render_json_auto(value = true, options={})
    is_success = !((value.class == String && value.start_with?('error_')) || value.to_s.to_i < 0)
    is_success ? render_json_s(value, options) : render_json_e(value)
  end


  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def render_500
    raise '500 exception'
  end


  def refresh_session(user_id)
    # 1. get current user
    @current_user = user_id.blank? ? nil : User.find(user_id)
    if current_user.present?
      # If current user is not empty, set cookie
      cookies[:auth_key] = {
        :value => user_id,
        :expires => Rails.application.config.permanent_signed_in_months.months.from_now,
        :domain => :all
      }
      return true
    else
      # If current user is empty, delete cookie
      cookies.delete(:auth_key, :domain => :all)
      return false
    end
  end




end
