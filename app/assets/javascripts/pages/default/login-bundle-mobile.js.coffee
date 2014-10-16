$(->
	account_ipt  = $('input[name="email_mobile"]')
	password_ipt = $('input[name="password"]')

	send_ajax = ->
		account  = account_ipt.val()
		password = password_ipt.val()
		rem      = $('.remember-me').attr('aria-checked')
		ref      = window.location.href.split('ref=')[1]
		if account.length > 0 && password.length > 0
			$.post("/sessions",{email_mobile:account,password:password,remember:rem,ref:ref},(ret)->
				if ret.success
					window.location.href = '/after_sign_in?ref=' + decodeURIComponent(ret.value.ref)
				else
					$('.align-center').text('用户名或密码错误')
					
			)

	$('.form input').focus(->
		$('.align-center').htmp('&nbsp;')
	)


	$('.login-btn').click((e)->
		e.preventDefault()
		send_ajax()
	)
)
