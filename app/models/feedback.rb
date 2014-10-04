require 'error_enum'
class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_UN_CHECK   = 0
  STATUS_CHECK_OK   = 1
  STATUS_CHECK_FAIL = 2

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
