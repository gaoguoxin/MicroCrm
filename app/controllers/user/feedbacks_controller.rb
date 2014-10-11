class User::FeedbacksController < User::UserController

  def index
    params[:t] ||= 'p'
    @data  = current_user.get_feedbacks(params)
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

end
