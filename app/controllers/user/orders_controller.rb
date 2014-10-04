class User::OrdersController <  User::UserController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    params[:t] = 'w' unless params[:t]
    @orders = auto_paginate current_user.my_course(params)
    Rails.logger.info('=====================')
    Rails.logger.info(@orders.inspect)
    Rails.logger.info('=====================')
  end

  def show

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
end
