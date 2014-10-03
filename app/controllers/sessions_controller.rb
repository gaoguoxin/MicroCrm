class SessionsController < ApplicationController

  def new
    redirect_to root_url if current_user.present?
  end

  #登录用户
  def create
    user = User.login(params)
    refresh_session(user.id.to_s,params[:remember]) if user.present? && user.class == User
    render_json_auto user and return
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
