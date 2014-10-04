class User::UserController < ApplicationController
  before_action :check_login
  layout "admin"
end
