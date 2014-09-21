$(->
	account_ipt  = $('input[name="email_mobile"]')
	password_ipt = $('input[name="password"]')

	flag_notice = (obj,msg)->
		obj.parents('.ipt-container').addClass("invalid")
		obj.siblings('.tooltip').text('').text(msg).removeClass('animated bounceOutRight').addClass('animated bounceInRight').show()

	remove_notice = (obj)->
		obj.parents('.ipt-container').removeClass("invalid")
		if obj.siblings('.tooltip:visible').length > 0
			obj.siblings('.tooltip').removeClass('animated bounceInRight').addClass('animated bounceOutRight').text('')

	check_required = ->
		email_mobile = $.trim(account_ipt.val())
		password     = $.trim(password_ipt.val())
		if email_mobile.length == 0
			flag_notice(account_ipt,'请输入帐号')
			return false

		if password.length == 0
			flag_notice(password_ipt,'请输入密码')
			return false
		send_ajax()

	send_ajax = ->
		account  = account_ipt.val()
		password = password_ipt.val()
		$.post("/sessions",{email_mobile:account,password:password},(ret)->
			if ret.success
				window.location.href = ret.value.ref
			else
				if ret.value.error_code == "error_3"
					flag_notice(account_ipt,'该用户不存在')
				else
					flag_notice(password_ipt,'您输入的密码有误')
		)

	# ipt_focus();

	$('.form input').focus(->
		remove_notice($(@))
	)


	$('.login-btn').click((e)->
		e.preventDefault()
		check_required()
	)

	$('password').keydown (e)->
		if e.which == 13
			$('.login-btn').click
)
