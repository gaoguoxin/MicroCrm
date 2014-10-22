require 'encryption'
class UsersController < ApplicationController
  before_action :check_login,only: [:index]

  def index
    @user = current_user
    @user.write_attribute(:password,Encryption.decrypt_password(@user.password))
  end

  def new
    @companis = Company.actived
    redirect_to root_url if current_user.present?
  end

  #注册用户
  def create
    user = User.regist(params)
    refresh_session(user.id.to_s) if user.present? && user.class == User
    render_json_auto user and return
  end


  def edit
    @user = current_user
  end


  #检查用户是否已经存在
  def check_exist
    exist = false
    user = User.check_exist(params)
    if user.present?
      exist = true
    end
    render_json_auto exist and return
  end

  #更新个人信息
  def update_info
    user_params[:ax]        = user_params[:ax] == 'true' ? true :false
    user_params[:crm]       = user_params[:crm] == 'true' ? true :false
    user_params[:softskill] = user_params[:softskill] == 'true' ? true :false
    user                    = User.update_info(user_params,current_user,current_user.id.to_s)
    render_json_auto user and return
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:mobile,:password,:type_of_position,:company_id,:city,:qq,:wechart,:skype,:ax,:crm,:softskill)
  end


end
