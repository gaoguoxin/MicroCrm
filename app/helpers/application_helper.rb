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

  def nav_actived?(cont,act_arr,para=nil)
    res = false
    if cont == controller_name
      if act_arr.include?(action_name)
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

  def admin_paginator_ajax(ckass,items,opt)
    render :partial => "/admin/partical/paginate_#{ckass}_ajax", :locals => {:common => items,:param => opt}
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
      return 'assets/avatar.jpg'
    end
  end


end
