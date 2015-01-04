class ApplicationController < ActionController::Base

  layout :diffrent_layout

  attr_reader :current_user

  protect_from_forgery with: :exception

  before_filter :init
  before_filter :force_tablet_html
  before_filter :check_devise
  has_mobile_fu
  helper_method :current_user


  def check_devise
    if is_mobile_device?
      params[:m] = true
    end
  end

  def force_tablet_html
    session[:tablet_view] = false
  end

  # init action
  def init
    @icp = '京ICP备06003108号-3'
    refresh_session(cookies[:auth_key])
  end

  def check_login
    unless current_user.present?
      if params[:m]
        redirect_to login_url(:ref => "#{request.protocol}#{request.host_with_port}#{request.fullpath}")
      else
        redirect_to login_url(:ref => "#{request.protocol}#{request.host_with_port}#{request.fullpath}")
      end
    end
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


  def page
    params[:page].to_i == 0 ? 1 : params[:page].to_i
  rescue
    1
  end

  def per_page
    params[:per_page].to_i == 0 ? 50 : params[:per_page].to_i
  rescue
    50
  end

  def auto_paginate(value, count = nil)
    retval = {}
    retval["current_page"] = page
    retval["per_page"] = per_page
    retval["previous_page"] = (page - 1 > 0 ? page - 1 : 1)
    if value.methods.include? :page
      count ||= value.count
      value = value.page(retval["current_page"]).per(retval["per_page"])
    elsif value.is_a?(Array) && value.count > per_page
      count ||= value.count
      value = value.slice((page - 1) * per_page, per_page)
    end

    if block_given?
      retval["data"] = yield(value)
    else
      retval["data"] = value
    end

    retval["total_page"] = ( (count || value.count )/ per_page.to_f ).ceil
    retval["total_page"] = retval["total_page"] == 0 ? 1 : retval["total_page"]
    retval["total_number"] = count || value.count
    retval["next_page"] = (page+1 <= retval["total_page"] ? page+1: retval["total_page"])
    retval
  end


  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def render_500
    raise '500 exception'
  end


  def refresh_session(user_id,remember=false)
    @current_user = user_id.blank? ? nil : User.find(user_id)
    if current_user.present?
      if remember.to_s == 'true'
        cookies[:auth_key] = {
          :value => user_id,
          :expires => Rails.application.config.permanent_signed_in_months.months.from_now,
          :domain => :all
        }
      else
        cookies[:auth_key] = {
          :value => user_id,
          :domain => :all
        }
      end
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
