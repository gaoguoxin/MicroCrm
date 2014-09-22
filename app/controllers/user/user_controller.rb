class User::UserController < ApplicationController
  before_action :check_login
  layout "admin"
  def check_login
    unless current_user.present?
      #redirect_to login_url(:ref => "#{request.protocol}#{request.host_with_port}#{request.fullpath}")
    else
      if current_user.is_admin?
        redirect_to admin_companies_url
      elsif current_user.is_manager?
        redirect_to manager_uesrs_url
      elsif current_user.is_viewer?
        redirect_to admin_companies_url
      end
    end
  end
end
