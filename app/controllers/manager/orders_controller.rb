class Manager::OrdersController < Manager::ManagerController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    params[:t] ||= 'o'
    #@courses  = auto_paginate current_user.manager_courses(params)
    # params[:per_page] = 1
    @courses  = auto_paginate Course.all
  end


  def get_employee
    render_json_auto current_user.do_multiple_order(params)
  end

  def get_order_list
    render_json_auto Order.get_company_list(current_user.id.to_s,params[:id])
  end
  
  def check
    if params[:type] == 'refuse'
      render_json_auto Order.check(params,current_user.id.to_s,true)
    else
      render_json_auto Order.check(params,current_user.id.to_s)
    end
  end

  def cancel
    render_json_auto Order.cancel(params[:id],current_user.id.to_s)
  end


  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    render_json_auto Order.manager_multiple_create(params,current_user.id.to_s)
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:status)
    end
end
