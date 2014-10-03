class CategoryController < ApplicationController
	def index
		params[:t] ||= 'crm'
		auto_paginate Course.search(params)
	end

	def show
		@course = Course.find(params[:id])
	end
end