$(->
	$('body').on('click','button.success',->
		$.post('/orders',{data:[window.c_id]},(ret)->
			if ret.success
				if ret.value == false
					window.location.href = '/login'
				else
					window.location.href = '/orders?w=true'
		)
		
	)
)