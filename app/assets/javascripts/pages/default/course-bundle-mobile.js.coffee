$(->
	$('body').on('click','button.success.start',->
		$.post('/orders',{data:[window.c_id]},(ret)->
			if ret.success
				if ret.value == false
					window.location.href = '/login'
				else
					window.location.href = '/orders?w=true'
		)
		
	)


	$('body').on('click','button.can_cancel',->
		cid = $(@).data('cid')
		$.post('/orders/cancel',{cid:cid},(ret)->
			if ret.success	
				window.location.href = '/orders'
		)		
	)

)