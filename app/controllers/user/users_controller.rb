class User::UsersController < User::UserController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @user = current_user
  end

  def update_info
    render_json_auto User.update_info(user_params,current_user,current_user.id.to_s) and return
  end

  def update_pwd
    render_json_auto User.update_pwd(current_user,params) and return
  end


  private
    def user_params
      params.require(:user).permit(:name, :type_of_position, :company_id, :city, :ax, :crm, :softskill,:qq,:wechart,:skype)
    end
end
