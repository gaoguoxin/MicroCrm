class CategoryController < ApplicationController
	def index
		params[:t] ||= 'crm'
		# courses =  Course.search(params)
		# if params[:m].present?
		# 	@courses = courses
		# else
		# 	@courses = auto_paginate courses
		# end
		@courses = Course.all
	end

	def show
		@course = Course.find(params[:id])
	end
end