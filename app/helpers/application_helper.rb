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

  def actived(c_name,pa=nil,str=nil)
  	if c_name == controller_name
  		if pa == str
  			return 'active'
  		else
  			return ''
  		end
  	else
  		return ''
  	end	
  end	


  def admin_paginator_ajax(items,status=nil,level=nil,type=nil,name=nil,account=nil)
    render :partial => "/admin/partical/paginate_ajax", :locals => {:common => items,:status => status,:level => level,:type => type,:name => name,:account => account}
  end


end
