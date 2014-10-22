$(->
	# img_height = $('.img-container img').height()
	# console.log(img_height)
	# $('.info-container').height(img_height)

	$('body').on('click','.multip-start',->
		id_arr = []
		$('li[aria-checked=true]').each(->
			id_arr.push $(@).data('id')
		)
		if id_arr.length > 0
			$.post('/orders',{data:id_arr},(ret)->
				if ret.success
					if ret.value == false
						window.location.href = '/login'
					else
						window.location.href = '/orders?w=true'
			)

	)
)
