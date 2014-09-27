class CategoryController < ApplicationController
	def index
		params[:t] ||= 'crm'
		Rails.logger.info('-----------------------------------------')
		Rails.logger.info(params.inspect)
		Rails.logger.info('-----------------------------------------')
	end
end