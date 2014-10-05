#= require regex
$(->
	name_ipt     = $('#name')
	email_ipt    = $('#email')
	mobile_ipt   = $('#mobile')
	password_ipt = $('#password')
	confirm_ipt  = $('#confirm_password')

	check_presense = ->
		if $.trim(name_ipt.val()).length == 0
			add_flag(name_ipt,'请认真填写您的姓名')
			return
		if $.trim(email_ipt.val()).length == 0 or !$.regex.isEmail(email_ipt.val()) 
			add_flag(email_ipt,'您的邮箱格式不正确')
			return
		if $.trim(mobile_ipt.val()).length == 0 or !$.regex.isMobile(mobile_ipt.val())
			add_flag(mobile_ipt,'您的手机号码格式不正确')
			return

		send_info_ajax()


	check_password = ->
		unless $.trim(password_ipt.val()).length > 0
			return false
		unless password_ipt.val() == confirm_ipt.val()
			add_flag(confirm_ipt,'两次密码不匹配')
			return
		send_password_ajax()

	send_password_ajax = ->
    	$.ajax({
    	    data: {password:$.trim( password_ipt.val() )},
    	    url: '/manager/users/update_pwd',
    	    method: "POST",
    	    success: (ret)->
    	      flash_notice('密码修改成功!')
    	})


	send_info_ajax = ->
		$.post('/manager/users/update_info',$('form.info').serialize(),(ret)->
			if ret.success
				flash_notice('信息修改成功!')
			else
				if ret.value.error_code == 'error_5'
					add_flag(email_ipt,'该邮箱已经存在!')
				else
					add_flag(mobile_ipt,'该手机号已经存在!')

		)

	delay = (ms, func) -> setTimeout func, ms

	go_top = ->
		$("html, body").animate({ scrollTop: 0 }, 500)

	flash_notice = (msg)->
		$('.flash-notice').text(msg).addClass('animated bounceInRight').show()
		go_top()
		delay 2000, ->  window.location.reload()

	add_flag =(obj,msg)->
		unless obj.prev('label').find('span').length > 0
			append_str = "<span>#{msg}</span>"
			obj.prev('label').append(append_str)
			obj.attr('aria-invalid',true)
		$("html, body").animate({ scrollTop: 0 }, 500)

	remove_flag = (obj)->
		obj.removeAttr('aria-invalid')
		obj.prev('label').find('span').remove()

	$('input').focus(->
		remove_flag($(@))
	)

	$('button.info-submit').click((e)->
		e.preventDefault()
		check_presense()
	)

	$('form.info input,textarea').keydown((e)->
		if e.witch == 13
			$('button.info-submit').click();
	)

	$('form.pwd button.pass-submit').click((e)->
		e.preventDefault()
		check_password();
	)

)
	