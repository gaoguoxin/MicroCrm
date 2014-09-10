class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def new
    @user = User.new
  end

  def create
    if params[:email].present? && params[:password].present?
      retval = User.create(email: params[:email],password: params[:password])
      if retval.present?
        refresh_session(retval.id.to_s)
        redirect_to edit_user_url(retval)
      end
    end
  end


  def edit
  end


  def login
    result = User.login_with_email_mobile(email: params[:email],password: params[:password])

    refresh_session(result['auth_key'])
    render_json_auto result and return
  end



  # def regist
  #   if params[:email].present? && params[:password].present?
  #     retval = User.create_new_user(email: params[:email],password: params[:password])
  #     render_json_auto(retval) and return
  #   end
  # end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :mobile, :company_id)
    end
end
