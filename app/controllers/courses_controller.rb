class CoursesController < ApplicationController
  before_action :set_course, only: [:show]
  before_action :check_login

  def index # 我的课程
  	#@courses = current_user.my_course(params)
    @courses = Course.all
  end

  def show

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
end
