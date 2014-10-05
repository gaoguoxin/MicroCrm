class Admin::AdminController < ApplicationController
  before_action :check_login
  before_action :check_role
  layout "admin"

  def refuse_viewer
    if current_user.is_viewer?
      if request.xhr?
        render_json_e('error_authorid') and return
      else
        redirect_to admin_companies_url
      end
    end
  end

  def check_role
    unless (current_user.is_admin? || current_user.is_viewer?)
      redirect_to root_path
    end
  end

end
