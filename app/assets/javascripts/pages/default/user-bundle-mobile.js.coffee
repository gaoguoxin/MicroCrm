$(->
	$('body').on('click','button.info-sub',(e)->
		e.preventDefault()
		$.post("/users/update_info",$('form').serialize(),(ret)->
			window.location.reload()
		)
	)
)