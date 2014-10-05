class Manager::ManagerController < ApplicationController
  before_action :check_login
  before_action :check_role
  layout "admin"


  def check_role
    unless current_user.is_manager?
      redirect_to root_path
    end
  end

end
