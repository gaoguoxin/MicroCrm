$(->
	$('body').on('click','.cancel-order',->
		$this = $(@)
		oid = $(@).data('id')
		$.get("/user/orders/#{oid}/cancel",{},(ret)->
			if ret.success
				$this.parents('tr').remove()
		)
	)
)