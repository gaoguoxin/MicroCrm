#= require regex
$(->
	name_ipt     = $('input[name="name"]')
	email_ipt    = $('input[name="email"]')
	mobile_ipt   = $('input[name="mobile"]')
	password_ipt = $('input[name="password"]')
	company_ipt  = $('select')
	flag_notice = (msg)->
		$('.align-center.notice').text(msg)
	remove_notice = ()->
		$('.align-center').html('&nbsp;')

	check_format = (ema,mob)->
		unless $.regex.isEmail($.trim(ema.val()))
			flag_notice('邮箱格式错误')
			return
		unless $.regex.isMobile($.trim(mob.val()))
			flag_notice('手机号格式错误')
			return
		send_ajax()

	check_required = ->
		name       = $.trim(name_ipt.val())
		email      = $.trim(email_ipt.val())
		mobile     = $.trim(mobile_ipt.val())
		password   = $.trim(password_ipt.val())
		company    = company_ipt.val()
		if name.length == 0
			flag_notice('请输入姓名')
			return 
		if email.length == 0
			flag_notice('请输入邮箱')
			return
		if mobile.length == 0
			flag_notice('请输入手机号')
			return		
		if password.length == 0
			flag_notice('请输入密码')
			return
		unless company 
			flag_notice('请选择所属单位')
			return
		check_format(email_ipt,mobile_ipt)	
		

	send_ajax = ->
		name        = name_ipt.val()
		r_email  	= email_ipt.val()
		r_mobile 	= mobile_ipt.val()
		password 	= password_ipt.val()
		company_id  = company_ipt.val() 
		$.post("/users",{name:name,email:r_email,mobile:r_mobile,password:password,company_id:company_id},(ret)->
			if ret.success
				window.location.href = "/"
			else
				if ret.value.error_code == "error_5"
					flag_notice('该邮箱已存在')
				if ret.value.error_code == "error_6"
					flag_notice('该手机号码已存在')
		)

	$('input,select').focus(->
		remove_notice()
	)
	


	$('.reg-btn').click((e)->
		e.preventDefault()
		check_required()
		
	)
)
