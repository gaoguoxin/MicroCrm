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
  belongs_to :course
  belongs_to :user

end
