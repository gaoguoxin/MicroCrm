class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update_info, :destroy]
  before_action :refuse_viewer, only: [:create,:update_info,:delete]
  def index
    if request.xhr?
      search
      render :partial => 'admin/users/index.js.erb', :locals => { :users => @users }
    else
      search
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def search
    @users = auto_paginate(User.admin_search(params))
  end

  def check_exist
    exist = false
    user = User.check_exist(params)
    if user.present?
      exist = true
    end
    render_json_auto exist and return
  end


  def create
    render_json_auto User.regist(user_params,true,false,current_user.id.to_s) and return 
  end

  def update_info  
    render_json_auto User.update_info(user_params,@user,current_user.id.to_s)
  end

  def delete
    render_json_auto @user.update_attributes(:status =>  User::STATUS_FINISHED)
    #render_json_auto @company.destroy
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :mobile, :password, :role_of_system, :type_of_position, :company_id, :city, :status, :ax, :crm, :softskill, :course_count, :course_manday_count,:qq,:wechart,:skype)
    end
end
