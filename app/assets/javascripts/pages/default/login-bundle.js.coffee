$(->
	ipt_focus = ->
		$('.form-group input').focus(->
			$(this).parent('.form-group').removeClass('has-error').removeClass('has-success')
			$(this).siblings('span.glyphicon').hide()
		)

	flag_notice = (obj,klass)->
		obj.parent('.form-group').addClass("#{klass}")
		$(this).siblings('span.glyphicon').show()

	# check_exist = (account)->
	# 	$.post("",{email_mobile:account},(result)->
	# 		console.log(result)

	check_required = ->
		email_mobile = $.trim($('email_mobile').val())
		password     = $.trim($('password').val())
		if email_mobile.length == 0
			flag_notice($('email_mobile'),'has_error')
			return false

		if password.length == 0
			flag_notice($('password'),'has_error')
			return false

	send_ajax = ->
	# 	$.post("",{email_mobile:account},(result)->
	# 		console.log(result)		


	ipt_focus();

	$('.form-group button').click((e)->
		e.preventDefault()
		check_required()
		send_ajax()
	)
)
