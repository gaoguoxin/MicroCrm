class SessionsController < ApplicationController

  def new
    redirect_to root_url if current_user.present?
  end

  #登录用户
  def create
    user = User.login(params)
    refresh_session(user.id.to_s) if user.present? && user.id.present?
    render_json_auto user and return
  end

  #注销用户
  def destroy
    refresh_session(nil)
    redirect_to root_url
  end
end
