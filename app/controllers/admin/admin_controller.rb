class Admin::AdminController < ApplicationController
  before_action :check_login
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

  def refuse_viewer
    if current_user.is_viewer?
      if request.xhr?
        render_json_e('error_authorid') and return
      else
        redirect_to admin_companies_url
      end
    end
  end

end
