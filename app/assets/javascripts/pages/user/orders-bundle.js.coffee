$(->

	$('body').on('click','.tablist li',->
		href = $(@).attr('href')
		$.get("#{href}",{},->)
	)

	$('body').on('click','.sure-operation',->
		oid = $(@).data('oid')
		$.get("/user/orders/#{oid}/cancel",{},(ret)->
			if ret.success
				$('a[data-id="#{oid}"]').parents('tr').remove()
				
		)		
	)

	open_confirm_box =(obj)->
		$.fancybox.open($('.confirm-box'),{
			padding:0,
			autoSize:true,
			scrolling:no,
			minWidth:300,
			openEffect:'none',
			closeEffect:'none',        
			helpers : {
			  overlay : {
			    locked: false,
			    closeClick: false,
			    css : {
			      'background' : 'rgba(51, 51, 51, 0.2)'
			    }
			  }
			},
			beforeShow:-> 
				$('.sure-operation').attr('data-oid',obj.data('id'))
			afterClose:->
				
		})	

)