class Manager::FeedbacksController < Manager::ManagerController

  def index
    params[:t] ||= 'p'
    @courses = auto_paginate current_user.manager_feedbacks(params)
  end

  def show

  end

end
