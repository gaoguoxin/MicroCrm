class User::FeedbacksController < User::UserController

  def index
    params[:t] ||= 'w'
    @courses = auto_paginate current_user.get_feedbacks(params)
  end

  def show

  end

end
