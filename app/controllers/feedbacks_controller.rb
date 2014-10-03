class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  def index
   
  end

  def show
  end

  def new
    @feedback = Feedback.new
  end


  def edit
  end


  def create
    feedback = Feedback.where(course_id:params[:c_id],user_id:current_user.id.to_s).first
    if feedback
      render_json_auto feedback.update_point(params,current_user.id.to_s)
    else
      render_json_auto Feedback.create_new(params,current_user.id.to_s)
    end
    
  end


  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end


    def feedback_params
      params[:feedback]
    end
end
