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
  field :question_1,type: Integer,default:0
  field :question_2,type: Integer,default:0
  field :question_3,type: Integer,default:0
  field :question_4,type: Integer,default:0
  field :question_5,type: Integer,default:0
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


  # 系统管理员查看某个课程的反馈信息
  def self.admin_find_feedbacks(params)
    data = []
    Order.where(course_id:params[:cid]).effective.map do |e|
      tmp_obj = {}
      user = e.user
      feed = user.feedbacks.where(course_id:params[:cid]).first
      tmp_obj['uname'] = user.name 
      tmp_obj['uid']   = user.id.to_s
      tmp_obj['status']= feed.present? ? feed.show_status : '尚未反馈'
      tmp_obj['cid']   = params[:cid]
      tmp_obj['f_id']  = feed.try(:id).to_s
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

  def show_status
    return '审核通过' if self.status ==  STATUS_CHECK_OK
    return '审核拒绝' if self.status ==  STATUS_CHECK_FAIL
    return '尚未审核' if self.status ==  STATUS_UN_CHECK 
  end


  def self.admin_search(params)
    result = Course.all
    params[:t] || 'w'
    if params[:status].present?
      result = result.where(status:params[:status])
    end
    if params[:code].present?
      result = result.where(code:/#{params[:code]}/)
    end
    if params[:name].present?
      result = result.where(name:/#{params[:name]}/)
    end

    if params[:content].present?
      result = result.where(content_type:params[:content])
    end

    if params[:city].present?
      result = result.where(city:params[:city])
    end
    
    if params[:start].present?
      result = result.where(:start_date.gte => params[:start_date])
    end
    if params[:end].present?
      result = result.where(:end_date.lte => params[:end_date])
    end
    if params[:t] == 'w'
      result = result.select{|e| e.feedbacks.count ==  0}  
    else
      result = result.select{|e| e.feedbacks.count > 0}    
    end
    return result
  end

  # admin change  point
  def self.change_point(params,admin_id)
    feedback = self.where(course_id:params[:cid],user_id:params[:uid]).first
    if feedback.present?
      feedback.update_attributes("#{params[:q]}".to_sym => params[:p],modifier_id:admin_id)
    else
      feedback = self.create(course_id:params[:cid],user_id:params[:uid],status:STATUS_UN_CHECK,creater_id:admin_id,modifier_id:admin_id,"#{params[:q]}".to_sym => params[:p])
    end 
    return feedback.score
  end

  # 系统管理员审核反馈
  def self.check_feedback(params)
    params['data'].values.each do |e|
      feedback = self.where(course_id:e['cid'] ,user_id:e['uid']).first
      if feedback.present?
        if params[:r] == 'pass'
          feedback.update_attributes(status:STATUS_CHECK_OK)
          feedback.add_point_to_course
        else
          feedback.update_attributes(status:STATUS_CHECK_FAIL)
        end
        return true      
      else
        return false
      end      
    end
  end

  #每审核通过一个反馈，计算分分值到对应的课程上
  def add_point_to_course
    course = Course.find(self.course_id)
    feeds  = Feedback.where(course_id:self.course_id,status:STATUS_CHECK_OK)
    total_score = 0
    teach_score = 0
    feeds.each do |feed|
      total_score += (feed.question_1 + feed.question_2 + feed.question_3 + feed.question_4 + feed.question_5)
      teach_score += (feed.question_4 + feed.question_5)
    end
    total_score = (total_score / feeds.count.to_f) / 5
    teach_score = (teach_score / feeds.count.to_f) / 2
    course.update_attributes(evaluation_general:total_score.round(1),evaluation_instructor:teach_score.round(1))
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
