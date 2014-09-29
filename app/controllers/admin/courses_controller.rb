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
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
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
