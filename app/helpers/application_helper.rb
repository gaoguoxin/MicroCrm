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

  def admin_paginator_ajax(ckass,items,opt)
    render :partial => "/admin/partical/paginate_#{ckass}_ajax", :locals => {:common => items,:param => opt}
  end


end
