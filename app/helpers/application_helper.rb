module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
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
end
