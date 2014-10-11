class OrdersController < ApplicationController
  before_action :check_login,only: [:index]
  def index
    unless  params[:m].present?
      redirect_to '/admin/orders?t=w' and return  if current_user.is_admin? || current_user.is_viewer?
      redirect_to '/manager/orders?t=w' and return  if current_user.is_manager?
      redirect_to '/user/orders?t=w' and return  if current_user.is_employee?
    else
      @orders = current_user.my_course(params)  
    end
  end

  def create
    unless current_user.present?
      #如果用户没有登录，那么先替他保管他所选得课程，在登录后直接为他创建报名记录
      cookies[:order_c_ids] = {
        :value => params[:data].join(','),
        :domain => :all
      }
      render_json_auto false
    else
      render_json_auto Order.create_new(params,current_user.id.to_s)
    end
  end







end
