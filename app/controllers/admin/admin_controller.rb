class Admin::AdminController < ApplicationController
  before_action :check_login
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

end
