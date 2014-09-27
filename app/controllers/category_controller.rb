class CategoryController < ApplicationController
	def index
		params[:t] ||= 'crm'
	end
end