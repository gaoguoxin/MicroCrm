class CategoryController < ApplicationController
	def index
		params[:t] ||= 'crm'
		courses =  Course.search(params)
		if params[:m].present?
			@courses = courses
		else
			@courses = auto_paginate  courses
		end
	end
end