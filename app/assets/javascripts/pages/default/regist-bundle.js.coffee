#= require regex
$(->
	name_ipt     = $('input[name="name"]')
	email_ipt    = $('input[name="email"]')
	mobile_ipt   = $('input[name="mobile"]')
	password_ipt = $('input[name="password"]')
	company_ipt  = $('select')
	flag_notice = (obj,msg)->
		if msg
			obj.parents('.ipt-container').addClass("invalid")
			if obj.siblings('.tooltip').length > 0 
				obj.siblings('.tooltip').text('').text(msg).removeClass('animated bounceOutRight').addClass('animated bounceInRight').show()
			else
				obj.parents('.ipt-container').find('.tooltip').text('').text(msg).removeClass('animated bounceOutRight').addClass('animated bounceInRight').show()
		else
			obj.parents('.ipt-container').addClass("valid")
	remove_notice = (obj)->
		obj.parents('.ipt-container').removeClass("invalid").removeClass('valid')
		if obj.siblings('.tooltip:visible').length > 0
			obj.siblings('.tooltip').removeClass('animated bounceInRight').addClass('animated bounceOutRight').text('').hide()
		else
			if obj.parents('.ipt-container').find('.tooltip:visible').length > 0
				obj.parents('.ipt-container').find('.tooltip:visible').removeClass('animated bounceInRight').addClass('animated bounceOutRight').text('').hide()	

	check_format = (obj)->
		name = obj.attr('name')
		if name == 'email'
			unless $.regex.isEmail($.trim(obj.val()))
				flag_notice(obj,'邮箱格式错误')
				return
		else
			unless $.regex.isMobile($.trim(obj.val()))
				flag_notice(obj,'手机号格式错误')
				return 
		check_regist("#{name}",$.trim(obj.val()))

	check_regist = (col,value)->
		data = {email:value} if col == 'email'
		data = {mobile:value} if col == 'mobile'
		if value.length > 0
			$.post("/users/check_exist",data,(ret)->
				if ret.success
					if ret.value
						if col == 'email'
							flag_notice(email_ipt,'该邮箱已被使用')
						else
							flag_notice(mobile_ipt,'该手机已被占用')
					else
						if col == 'email'
							flag_notice(email_ipt)
						else
							flag_notice(mobile_ipt)							
			)		

	check_required = ->
		name       = $.trim(name_ipt.val())
		email      = $.trim(email_ipt.val())
		mobile     = $.trim(mobile_ipt.val())
		password   = $.trim(password_ipt.val())
		company    = company_ipt.val()

		if name.length == 0
			flag_notice(name_ipt,'请输入姓名')
			return 
		if email.length == 0
			flag_notice(email_ipt,'请输入邮箱')
			return
		if mobile.length == 0
			flag_notice(mobile_ipt,'请输入手机号')
			return		
		if password.length == 0
			flag_notice(password_ipt,'请输入密码')
			return
		unless company 
			flag_notice(company_ipt,'请选择所属单位')
			return		
		send_ajax()

	send_ajax = ->
		name        = name_ipt.val()
		r_email  	= email_ipt.val()
		r_mobile 	= mobile_ipt.val()
		password 	= password_ipt.val()
		company_id  = company_ipt.val() 
		$.post("/users",{name:name,email:r_email,mobile:r_mobile,password:password,company_id:company_id},(ret)->
			if ret.success
				window.location.href = "/user/users"
			else
				if ret.value.error_code == "error_5"
					$('.email.tooltip').show()
				if ret.value.error_code == "error_6"
					$('.mobile.tooltip').show()
		)

	$('.form input,.form select').focus(->
		remove_notice($(@))
	)

	email_ipt.blur  ->
		check_format(email_ipt)
	mobile_ipt.blur  ->
		check_format(mobile_ipt)
	


	$('.reg-btn').click((e)->
		e.preventDefault()
		check_required()
		
	)

	$('password').keydown (e)->
		if e.which == 13
			$('.form-group button').click
)
