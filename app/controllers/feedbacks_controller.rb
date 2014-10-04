class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  before_action :check_login,only: [:index]
  def index
    unless params[:m].present?
      redirect_to '/admin/feedbacks?t=w' and return  if current_user.is_admin? || current_user.is_viewer?
      redirect_to '/manager/feedbacks?t=w' and return  if current_user.manager?
      redirect_to '/user/feedbacks?t=w' and return  if current_user.manager?    
    else
      params[:t] ||= 'w'
      @courses = current_user.get_feedbacks(params)
    end
  end

  def show
  end



  def create
    feedback = Feedback.where(course_id:params[:c_id],user_id:current_user.id.to_s).first
    if feedback
      render_json_auto feedback.update_point(params,current_user.id.to_s)
    else
      render_json_auto Feedback.create_new(params,current_user.id.to_s)
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
