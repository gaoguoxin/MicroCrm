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
		rem      = $('.remember-me').attr('aria-checked')
		ref      = window.location.href.split('ref=')[1]
		$.post("/sessions",{email_mobile:account,password:password,remember:rem,ref:ref},(ret)->
			if ret.success
				window.location.href = '/after_sign_in?ref=' + decodeURIComponent(ret.value.ref)
				# window.location.href = decodeURIComponent(ret.value.ref)
			else
				if ret.value.error_code == "error_3"
					flag_notice(account_ipt,'该用户不存在')
				else
					flag_notice(password_ipt,'您输入的密码有误')
		)


	open_forget_box = ->
		$.fancybox.open($('.forget-box'),{
			padding:0,
			autoSize:true,
			scrolling:no,
			minWidth:500,
			openEffect:'none',
			closeEffect:'none',        
			helpers : {
			  overlay : {
			    locked: false,
			    closeClick: false,
			    css : {
			      'background' : 'rgba(51, 51, 51, 0.2)'
			    }
			  }
			},
			beforeShow:-> 
				
			afterClose:->
				
		})			

	$('body').on('focus','.form input',->
		remove_notice($(@))
	)


	$('body').on('click','.login-btn',(e)->
		e.preventDefault()
		check_required()
	)

	$('body').on('keydown','password',(e)->
		if e.which == 13
			$('.login-btn').click()
	)

	$('body').on('click','a.forget-password',(e)->
		open_forget_box()
	)

	$('body').on('click','span.f-btn',->
		account = $('.f-mobile').val()
		if account.length > 0
			$.post("/sessions/fpwd",{mobile:account},(ret)->
				if ret.success
					$('.forget-box .box').text('新密码已发送到您的手机!')
				else
					$('.forget-box .box').text('该手机号不存在')	
			)
	)

	$('body').on('keydown','.f-mobile',(e)->
		if e.which == 13
			$('span.f-btn').click()
	)


)
