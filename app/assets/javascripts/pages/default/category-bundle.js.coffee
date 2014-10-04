$(->
	$('body').on('click','.select-tool .checklist li',->
		if $(@).attr('aria-checked') == 'true'
			$('.select-list li').attr('aria-checked',true)
		else	
			$('.select-list li').attr('aria-checked',false)
	)


	$('body').on('click','.multip-start',->
		if $('.select-list li[aria-checked="true"]').length > 0
			id_arr = []
			$('.select-list li[aria-checked="true"]').each(->
				id_arr.push $(@).data('id')
			)
			if id_arr.length > 0
				generate_order(id_arr)
	)

	$('body').on('click','button.start',->
		id = $(@).data('id')
		generate_order([id])
	)

	$('body').on('click','button.feedback',->
		h = $(@).data('id')
		window.open("/courses/#{h}");
	)



	generate_order = (data)->
		$.post('/orders',{data:data},(ret)->
			if ret.success
				if ret.value == false
					window.location.href = '/login'
				else
					window.location.href = '/orders?w=true'
		)			

)