class Admin::CoursesController < Admin::AdminController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :refuse_viewer, only: [:new,:edit,:match_manager,:match_student,:create,:delete,:destroy]
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.where(status:params[:status])
  end


  def index
    if request.xhr?
      search
      render :partial => 'admin/courses/index.js.erb', :locals => { :courses => @courses }
    else
      search
    end
     
  end

  def search
    @courses = auto_paginate(Course.search(params))
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  def match_manager
    render_json_auto Company.match_course_manager(params[:data])
  end

  def match_student
    render_json_auto User.match_course_student(params[:data])
  end

  # POST /courses
  # POST /courses.json
  def create
    course_params['notice_at'] = course_params['notice_at'].gsub('，',',')
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        format.html { redirect_to admin_courses_url(status:@course.status) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      course_params['notice_at'] = course_params['notice_at'].gsub('，',',')
      if course_params[:status] != @course.status
        #课程的状态发生了变化
        @course.update(course_params)
        redirect_to admin_courses_url(status:@course.status)
      else
        if course_params[:city] != @course.city
          #课程状态没有发生变化并且上课的城市发生了变更，要将原来的课程取消，并用现在的数据创建一个新的课程
          @new_course = Course.create(course_params)
          course_params[:status] = Course::STATUS_CODE_4
          @course.update(course_params)
          redirect_to admin_courses_url(status:@new_course.status)
        else
          #课程状态和城市都没有发生变化，但是其他的内容发生了变化。
          @course.update(course_params)
          redirect_to admin_courses_url(status:@course.status)
        end
      end
    end
  end




  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to admin_courses_url(status:@course.status)}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:manager_condition, :trainee_condition,:notice_at,:name_cn,:name_en,:code,:audience,:difficulty_level,:delivery_type,:instructor,:instructor_avatar,:instructor_desc,:charge_category,:content_type,:price_level1,:price_level2,:price_level3,:start_date,:start_time,:end_date,:end_time,:duration,:lim_num,:city,:address,:classroom,:description,:evaluation_general,:evaluation_instructor,:waiting_acctadmin_approval_num,:waiting_sysadmin_approval_num,:valid_registration_num,:canceled_num,:attendee_num,:notice_content,:status)
    end
end
