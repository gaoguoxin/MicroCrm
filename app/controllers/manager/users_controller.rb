class Manager::UsersController < Manager::ManagerController
  before_action :set_user, only: [:show, :edit, :update, :delete,:update_info]

  # GET /users
  # GET /users.json
  def minfo
    @user = current_user
  end


  def index
    if request.xhr?
      search
      render :partial => 'manager/users/index.js.erb', :locals => { :users => @users }
    else
      search
    end
  end

  def search
    @users = auto_paginate(User.manager_search(params,current_user.id.to_s))
  end  


  def create
    render_json_auto User.regist(user_params,false,true,current_user.id.to_s) and return 
  end

  def update_info  
    render_json_auto User.update_info(user_params,@user,current_user.id.to_s)
  end




  # def update_info
  #   render_json_auto User.update_info(user_params,current_user,current_user.id.to_s) and return
  # end

  def update_pwd
    render_json_auto User.update_pwd(current_user,params) and return
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def delete
    qt_company = Company.where(name:/其他/).first
    render_json_auto @user.update_attributes(:company_id =>  qt_company.id.to_s)
    #render_json_auto @company.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id].present?
        @user = User.find(params[:id])
      else
        @user = current_user
      end
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :mobile, :password, :type_of_position, :city,:ax, :crm, :softskill,:qq,:wechart,:skype)
    end
end
