class CoursesController < ApplicationController
  before_action :set_course, only: [:show]
  before_action :check_login,only: [:index]

  def index # 我的课程
  	@courses = current_user.my_course(params)
    #@courses = Course.all
  end

  def show
    @feedback = @course.feedbacks.where(user_id:current_user.try(:id).to_s).first
  end

  #pc端搜索课程名称
  def search
    @courses = auto_paginate( Course.search(params) )
  end

  def do_search
    #@courses = Course.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
end
