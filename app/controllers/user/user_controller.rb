class User::UserController < ApplicationController
  before_action :check_login
  before_action :check_role
  layout "admin"

  def check_role
    unless current_user.is_employee?
      redirect_to root_path
    end
  end

end
