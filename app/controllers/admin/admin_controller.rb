class Admin::AdminController < ApplicationController
  before_action :check_login,:special_style
  layout "admin"
  def check_login
    unless current_user.present?
      redirect_to login_url(:ref => "#{request.protocol}#{request.host_with_port}#{request.fullpath}")
  	else
  	  if current_user.is_manager? || current_user.is_employee?
  	  	redirect_to root_url
  	  end
    end
  end

  def special_style
    @special_left  = 'admin-left'
    @special_right = 'admin-right'
  end

end
