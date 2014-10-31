class UserMailer < ActionMailer::Base
  default from: "no-reply@dynamicsreadiness.com"

  def lesson_published_to_manager(mlist,opt)
  	@course = Course.find(opt[:course_id])
  	@condition = opt[:condition]
    mlist.each do |email|
    	mail(to: email, subject: '新课程提醒')
    end
  end


  def lesson_published_to_student(mlist,opt)
  	@course = Course.find(opt[:course_id])
  	@condition = opt[:condition]
    mlist.each do |email|
    	mail(to: email, subject: '新课程提醒')
    end
  end

end
