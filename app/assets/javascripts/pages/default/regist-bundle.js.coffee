$(->
	account_ipt  = $('input[name="email_mobile"]')
	password_ipt = $('input[name="password"]')
	ipt_focus = ->
		$('.form-group input').focus(->
			$(this).parent('.form-group').removeClass('has-error').removeClass('has-success')
			$(this).siblings('span.glyphicon').hide().siblings('.tooltip').hide()
		)

	flag_notice = (obj,klass)->
		obj.parent('.form-group').addClass("#{klass}")
		obj.siblings('span.glyphicon').show()


	check_regist = ->
		account  = $.trim(account_ipt.val())
		if account.length > 0
			$.post("/users/check_exist",{email_mobile:account},(ret)->
				if ret.success
					if ret.value
						$('.account.tooltip').show()
					else
						flag_notice(account_ipt,'has-success')
						
			)		

	check_required = ->
		email_mobile = $.trim(account_ipt.val())
		password     = $.trim(password_ipt.val())
		if email_mobile.length == 0
			flag_notice(account_ipt,'has-error')
			return false

		if password.length == 0
			flag_notice(password_ipt,'has-error')
			return false
		send_ajax()

	send_ajax = ->
		account  = account_ipt.val()
		password = password_ipt.val()
		$.post("/users",{email_mobile:account,password:password},(ret)->
			if ret.success
				window.location.href = "/users/#{ret.value._id.$oid}/edit"
			else
				if ret.value.error_code == "error_0"
					$('.account.tooltip').show()
		)

	ipt_focus();

	account_ipt.blur  ->
		check_regist()
	

	account_ipt.keydown (e)->
		if e.which == 13
			check_regist()
	


	$('.form-group button').click((e)->
		e.preventDefault()
		check_required()
	)

	$('password').keydown (e)->
		if e.which == 13
			$('.form-group button').click
)
