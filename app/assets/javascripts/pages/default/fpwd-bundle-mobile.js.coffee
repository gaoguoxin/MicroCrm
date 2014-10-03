$(->
	account_ipt  = $('input[name="mobile"]')

	send_ajax = ->
		account  = account_ipt.val()
		$.post("/sessions/fpwd",{mobile:account},(ret)->
			if ret.success
				$('.align-center').text('新密码已发送到您的手机')
				setTimeout(window.location.href = '/',2000)
			else
				$('.align-center').text('该手机号不存在')
				
		)

	$('.form input').focus(->
		$('.align-center').htmp('&nbsp;')
	)


	$('.find-btn').click((e)->
		e.preventDefault()
		send_ajax()
	)
)
