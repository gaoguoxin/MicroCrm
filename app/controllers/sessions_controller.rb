class SessionsController < ApplicationController

  before_filter :check_login, :only => [:after_sign_in]
  def new
    redirect_to root_url if current_user.present?
  end

  #登录用户
  def create
    user = User.login(params)
    refresh_session(user.id.to_s,params[:remember]) if user.present? && user.class == User
    render_json_auto user and return
  end

  
  def after_sign_in
    #登录进来后处理新那些在登录之前定的报名记录
    if cookies[:order_c_ids].present?
      Order.create_new({data:cookies[:order_c_ids].split(',')},current_user.id.to_s)
      cookies.delete(:order_c_ids, :domain => :all)
      redirect_to orders_path
    else
      redirect_to (params[:ref].blank? ? root_path : params[:ref])
    end 
  end


  def fpwd
    if request.post?
      mobile = params[:mobile]
      render_json_auto User.find_pwd(mobile)
    end
  end

  #注销用户
  def destroy
    refresh_session(nil)
    redirect_to root_url
  end





end
