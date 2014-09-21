class User::UserController < ApplicationController
  before_action :check_login
  layout "admin"
  def check_login
    unless current_user.present?
      #redirect_to login_url(:ref => "#{request.protocol}#{request.host_with_port}#{request.fullpath}")
    end
  end
end
