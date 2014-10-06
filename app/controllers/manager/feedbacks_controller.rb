class Manager::FeedbacksController < Manager::ManagerController

  def index
    params[:t] ||= 'p'
    @courses = auto_paginate current_user.manager_feedbacks(params)
  end

  def get_feed_info
  	render_json_auto Feedback.find_special_company_colums(params,current_user.id.to_s)
  end

end
