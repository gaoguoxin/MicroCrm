class Admin::CardsController < Admin::AdminController
  before_action :refuse_viewer
  before_action :set_card, only: [:show, :edit, :update, :delete,:update_info]
  before_action :set_companies,only: [:index,:new,:edit]
  def index
    if request.xhr?
      search
      render :partial => 'admin/cards/index.js.erb', :locals => { :cards => @cards }
    else
      search
    end
  end

  def new
  end

  def edit
  end

  def search
    @cards = auto_paginate(Card.search(params))
  end

  def search_manager
    render_json_auto User.search_manager(params) and return
  end


  def create
    render_json_auto Card.create_new(card_params) and return 
  end

  def update_info
    render_json_auto Card.update_info(card_params,@card)
  end

  def delete
    #render_json_auto @card.update_attributes(:status_execution => Card::EXEC_STATUS_2)
    render_json_auto @card.destroy
  end

  private

    def set_card
      @card = Card.find(params[:id])
    end

    def set_companies
      @companis = Company.actived.except_other
    end

    def card_params
      params.require(:card).permit(:serial_number, :type,:status_payment,:status_execution,:quantity_purchased,:quantity_used,:amount_payable,:amount_paid,:buyer_voucher,:receipt_num,:buyer,:buyer_mobile,:date_paid,:finished_at,:post_address,:company_id)
    end
end
