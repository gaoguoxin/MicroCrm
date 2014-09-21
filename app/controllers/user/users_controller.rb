class User::UsersController < User::UserController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    
  end

  def update_info
    current_user = User.find('541e8ce35468690829000000')
    render_json_auto current_user.update_info(user_params) and return
  end

  def update_pwd
    render_json_auto User.update_pwd(user_params) and return
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :mobile, :password,:position,:description,:qq,:wechart,:skype,:gtalk,:twitter,:facebook)
    end
end
