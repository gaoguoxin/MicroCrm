class Manager::CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    # status
    # expired    我已经上过的课
    # opening    我正在上得课
    # oreceived  已经被接受并等待的课程
    # refused    已经报名但审核未通过的课程
    # wait       待报名的课程    
  end

  def show

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
end
