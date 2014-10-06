require 'error_enum'
class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_UN_CHECK   = 0
  STATUS_CHECK_OK   = 1
  STATUS_CHECK_FAIL = 2

  QUESTION_ONE   = '这里是问题1'
  QUESTION_TWO   = '这里是问题2'
  QUESTION_THREE = '这里是问题3'
  QUESTION_FOUR  = '这里是问题4'
  QUESTION_FIVE  = '这里是问题5'

  field :status,type: Integer,default: 0 #审核状态
  field :question_1,type: Integer
  field :question_2,type: Integer
  field :question_3,type: Integer
  field :question_4,type: Integer
  field :question_5,type: Integer
  field :score,type:Float
  field :creater_id,type: String
  field :modifier_id,type: String
  belongs_to :course
  belongs_to :user

  before_save :count_score

  def self.create_new(params,u_id)
    u = User.find(u_id)
    order = u.orders.where(course_id:params[:c_id],state:Order::STATE_CODE_1).first
    return ErrorEnum::ORDER_NOT_EXIST unless order.present?
    return self.create(question_1:params[:data][0],question_2:params[:data][1],question_3:params[:data][2],question_4:params[:data][3],question_5:params[:data][4],course_id:params[:c_id],user_id:u_id,modifier_id:u_id,creater_id:u_id)
  end


  #企业管理员查看某个课程下所有参与员工的反馈情况
  def self.find_special_company_colums(params,manager_id)
    manager = User.find(manager_id)
    employees = manager.employees
    data = []
    Order.where(course_id:params[:cid],:user_id.in => employees).effective.map do |e|
      tmp_obj = {}
      user = e.user
      feed = user.feedbacks.where(course_id:params[:cid]).first
      tmp_obj['uname'] = user.name 
      tmp_obj['q_1']   = feed.try(:question_1) || '--' 
      tmp_obj['q_2']   = feed.try(:question_2) || '--'
      tmp_obj['q_3']   = feed.try(:question_3) || '--'
      tmp_obj['q_4']   = feed.try(:question_4) || '--'
      tmp_obj['q_5']   = feed.try(:question_5) || '--'
      tmp_obj['tot']   = feed.try(:score)      || '--'
      data << tmp_obj
    end

    return data

  end

  def update_point(params,u_id)
    return self.update_attributes(question_1:params[:data][0],question_2:params[:data][1],question_3:params[:data][2],question_4:params[:data][3],question_5:params[:data][4],modifier_id:u_id)
  end

  def lock?
    self.status !=  STATUS_UN_CHECK
  end

  private
  def count_score
    self.score = (question_1 + question_2 + question_3 + question_4 + question_5) / 5.0
  end

end
