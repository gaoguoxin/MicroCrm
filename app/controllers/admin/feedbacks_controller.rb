class Admin::FeedbacksController < Admin::AdminController
  before_action :refuse_viewer, only: [:change_point,:check_feedback]
  def index
    if request.xhr?
      search
      render :partial => 'admin/feedbacks/index.js.erb', :locals => { :courses => @courses }
    else
      search
    end
  end

  def search
    params[:t] || 'w'
    @courses = auto_paginate(Feedback.admin_search(params))
  end


  def get_feed_info
    render_json_auto Feedback.admin_find_feedbacks(params)
  end

  def change_point
    render_json_auto Feedback.change_point(params,current_user.id.to_s)
  end

  def check_feedback
    render_json_auto Feedback.check_feedback(params)
  end

end
