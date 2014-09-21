class ApplicationController < ActionController::Base

  layout :diffrent_layout

  attr_reader :current_user

  protect_from_forgery with: :exception

  before_filter :init
  before_filter :force_tablet_html

  has_mobile_fu 
  helper_method :current_user
  


  def force_tablet_html
    session[:tablet_view] = false
  end
  
  # init action
  def init
    refresh_session(cookies[:auth_key])
  end

  def render_json(is_success = true, &block)
    @is_success = is_success.present?
    render :json => {
                :value => block_given? ? yield(is_success) : is_success ,
                :success => !!@is_success
              }
  end
  
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
    @current_user = user_id.blank? ? nil : User.find(user_id)
    if current_user.present?
      cookies[:auth_key] = {
        :value => user_id,
        :expires => Rails.application.config.permanent_signed_in_months.months.from_now,
        :domain => :all
      }
      return true
    else
      cookies.delete(:auth_key, :domain => :all)
      return false
    end
  end


  def diffrent_layout
    if controller_name == 'sessions' || controller_name == 'users'
      false
    else
      "default"
    end
  end





end
