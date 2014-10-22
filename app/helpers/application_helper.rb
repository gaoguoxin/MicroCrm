module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def selected(inst,att,v)
    val = ''
    val = 'selected' if inst.present? && inst.attributes["#{att}"] == v
    return val
  end

  def default(inst,att)
    val = ''
    if inst.present?
      val = inst.attributes["#{att}"]
    end
    return val
  end

  def actived(c_name,a_name,param=nil,str=nil)
    if c_name == controller_name && a_name == action_name && param == str
      return 'active'
    else
      return ''
    end
  end

  def nav_actived?(cont,act,para=nil)
    res = false
    if cont == controller_name
      if act == action_name
        if para.present?
          if para == params[:t]
            res = true
          end
        else
          res = true
        end
      end
    end
    return res
  end	

  def sub_tab_text(status)
    return '规划中的课程' if status.to_i == 0
    return '已发布的课程' if status.to_i == 1
    return '授课中的课程' if status.to_i == 2
    return '已交付的课程' if status.to_i == 3
    return '已取消的课程' if status.to_i == 4
  end

  def user_sub_tab_text(opt)
    if opt['t'] == 'w'
      return '已报名的课程'
    elsif opt['t'] == 'n'
      return '进行中的课程'
    elsif opt['t'] == 'p'
      return '参与过的课程'
    else
      return '已取消的课程'
    end
  end

  def sub_bread(status)
    return '规划中的课程' if status.to_i == 0
    return '已发布的课程' if status.to_i == 1
    return '授课中的课程' if status.to_i == 2
    return '已交付的课程' if status.to_i == 3
    return '已取消的课程' if status.to_i == 4
  end

  def course_notice(status)
    return '规划中的课程，可以随意修改和删除' if status.to_i == 0
    return '涉及到上课时间、地点的变更，或者取消课程，会发短信通知与课人员' if status.to_i == 1
    return '授课中的课程，信息不允许更改！' if status.to_i == 2
    return '课程已结束，开始收集反馈信息！' if status.to_i == 3
    return '取消的课程， 可以删除！' if status.to_i == 4
  end

  def order_notice(opt)
    if opt == 'w'
      return '已报名的课程，表示您已经报名了该课程，需要管理员进行审核才能进行听课'
    elsif opt == 'n'
      return '进行中的课程，表示您的报名已经通过审核，并且当前该课程正在进行中'
    elsif opt == 'p'
      return '参与过的课程，表示您的报名通过了审核并且您已经参与了该课程'
    else
      return '已取消的课程，表示您或者您的单位管理或者系统管理员取消了您对该课程的报名'
    end    
  end

  def manager_order_status(str,desc=false)
    if str == 'o'
      return '开放中的课程' unless desc
      return '开放中的课程表示当前课程处于接受报名状态，您可以选择这些课程为公司员工报名'
    elsif str == 'w'
      return '已报名的课程' unless desc
      return '已报名的课程表示这些课程本公司员工已经报名，需要您给予审核，并且只有您和系统教务审核后才可以参与课程'
    elsif str == 'n'
      return '进行中的课程' unless desc
      return '进行中的课程表示这些课程目前处于上课状态，此时您公司的员工已经在听课'
    elsif str == 'p'
      return '参与过的课程' unless desc
      return '参与过的课程标示这些课程您公司的员工已经参与'
    else
      return '取消的课程' unless desc
      return '取消的课程表示您公司的员工已经报名并且得到了系统教务的审核通过，但是被公司员工或者您给予取消的课程'
    end
  end

  def sub_order_nav(s,desc=false)
    if s == 'o'
      return '尚未开课的报名表' unless desc
      return '您需要对尚未开课的报名表进行审核,只有被系统管理员审核的报名人员才可以参与课程'
    elsif s == 'n'
      return '授课中的报名表' unless desc
      return '授课中的报名表,列出的时当前正在参与授课中的报名人员列表'
    elsif s == 'p'
      return '已结课的报名表' unless  desc
      return '在这里您需要对已经结课的报名表做出勤的矫正'
    else
      return '取消课程的报名表' unless desc
      return '这里列出的是系统审核已经通过但是被取消的报名记录'
    end
  end


  def admin_paginator_ajax(ckass,items,opt)
    render :partial => "/admin/partical/paginate_#{ckass}_ajax", :locals => {:common => items,:param => opt}
  end

  def manager_paginator_ajax(ckass,items,opt)
    render :partial => "/manager/partical/paginate_#{ckass}_ajax", :locals => {:common => items,:param => opt}
  end


  def change_bg(para)
    if para[:w].present?
      return 'yellow'
    elsif para[:p]
      return 'orange'
    else
      return 'red'
    end
  end


  def show_small_avatar(course)
    if course.instructor_avatar.small.url
      return course.instructor_avatar.small.url
    else
      return 'small_avatar.jpg'
    end
  end

  def show_thumb_avatar(course)
    if course.instructor_avatar.thumb.url
      return course.instructor_avatar.thumb.url
    else
      return 'thumb_avatar.jpg'
    end
  end

  def show_banner_avatar(course)
    if course.instructor_avatar.banner.url
      return course.instructor_avatar.banner.url
    else
      return 'banner_avatar.jpg'
    end
  end

  def can_feed?(course)
    if course.start_date <= Date.today
      return true
    else
      return false
    end
  end

  def checked?(v,s)
    if v.to_i == s.to_i
      return true
    else
      return false
    end
  end

  def inline_svg(path)
      File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end

  def show_mobile_nav(str)
    return "AX培训课" if str == 'ax'
    return "CRM培训课" if str == 'crm'
    return "软技能培训课"  if str == 'ax_crm'
    return "免费研讨班" if str == 'f'
  end


end
