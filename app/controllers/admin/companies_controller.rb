class Admin::CompaniesController < Admin::AdminController
  before_action :set_company, only: [:show, :edit, :update, :delete,:update_info]
  before_action :refuse_viewer, only: [:search_manager,:create,:update_info,:delete]
  def index
    params[:per_page] = 1
    if request.xhr?
      search
      render :partial => 'admin/companies/index.js.erb', :locals => { :companies => @companies }
    else
      search
    end
     
  end

  def new
  end

  def edit
  end

  def search
    @companies = auto_paginate(Company.search(params))
  end

  def search_manager
    render_json_auto User.search_manager(params) and return
  end


  def create
    render_json_auto Company.create_new(company_params) and return 
  end

  def update_info
    render_json_auto Company.update_info(company_params,@company)
  end

  def delete
    render_json_auto @company.update_attributes(:status => Company::STATUS_FINISHED)
    #render_json_auto @company.destroy
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end


    def company_params
      params.require(:company).permit(:name, :manager_id,:status,:type,:level,:pri_serv,:main_area,:sales_count,:ax_presales_count,:crm_presales_count,:ax_consultant_count,:crm_consultant_count,:dynamic_count,:description)
    end
end
