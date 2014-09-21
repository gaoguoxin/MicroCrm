$(->
	account_ipt  = $('input[name="email_mobile"]')
	password_ipt = $('input[name="password"]')
	ipt_focus = ->
		$('.form input').focus(->
			$(this).parents('.ipt-container').removeClass('invalid')
		)

	flag_notice = (obj,klass)->
		obj.parents('.ipt-container').addClass("#{klass}")

	check_required = ->
		email_mobile = $.trim(account_ipt.val())
		password     = $.trim(password_ipt.val())
		if email_mobile.length == 0
			flag_notice(account_ipt,'invalid')
			return false

		if password.length == 0
			flag_notice(password_ipt,'invalid')
			return false
		send_ajax()

	send_ajax = ->
		account  = account_ipt.val()
		password = password_ipt.val()
		$.post("/sessions",{email_mobile:account,password:password},(ret)->
			if ret.success
				window.location.href = "/user/users"
			else
				if ret.value.error_code == "error_3"
					$('.account.tooltip').addClass('animated bounceInRight').show()
				else
					$('.password.tooltip').addClass('animated bounceInRight').show()
		)

	ipt_focus();

	$('.login-btn').click((e)->
		e.preventDefault()
		check_required()
	)

	$('password').keydown (e)->
		if e.which == 13
			$('.login-btn').click
)
