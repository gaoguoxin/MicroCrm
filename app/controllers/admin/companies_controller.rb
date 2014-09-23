class Admin::CompaniesController < Admin::AdminController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.all
  end


  def show
  end


  def edit
  end

  def search_manager
    render_json_auto User.search_manager(params) and return
  end


  def create
    render_json_auto Company.create_new(company_params) and return 
  end

  def update_info
    Rails.logger.info('=================================')
    Rails.logger.info(company_params.inspect)
    Rails.logger.info('=================================')
  end


  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end


    def company_params
      params.require(:company).permit(:name, :manager_id,:status,:type,:level,:pri_serv,:main_area,:sales_count,:ax_presales_count,:crm_presales_count,:ax_consultant_count,:crm_consultant_count,:dynamic_count,:description)
    end
end
