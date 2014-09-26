$(->
	$("#search_start,#search_end").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})

	email_ipt    = $('#email') 
	mobile_ipt   = $('#mobile')
	password = $.trim($('#password').val())	

	delay = (ms, func) -> setTimeout func, ms

	go_top = ->
		$("html, body").animate({ scrollTop: 0 }, 500)

	flash_notice = (msg)->
		$('.flash-notice').text(msg).addClass('animated bounceInRight').show()
		go_top()
		delay 2000, ->  window.location.reload()

	remove_notice = ->
		$('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight')


	check_exist = (obj)->
		data = {email:obj.val()} if obj.attr('id') == 'email'
		data = {mobile:obj.val()} if obj.attr('id') == 'mobile'
		data.id = $('input[name="id"]').val()
		$.post("/admin/users/check_exist",data,(ret)->
			if ret.success
				if ret.value
					obj.parents('.padded').addClass('invalid').removeClass('valid')
				else
					obj.parents('.padded').addClass('valid').removeClass('invalid')
	
		)

	check_presense = (obj)->
		submit = true
		if obj.hasClass('upd')
			check_obj = $('#name,#email,#mobile')
		else
			check_obj = $('#name,#email,#mobile,#password')

		check_obj.each(->
			v = $.trim($(@).val())
			if v.length <= 0
				$(@).parents('.padded').addClass('invalid').removeClass('valid')
				go_top()
				submit = false
				return 
		)

		submit_user_info(obj)  if submit

	submit_user_info = (obj)->
		data = $('form.new-user').serialize()
		if obj.hasClass('upd')
			ajax_url = "/admin/users/update_info"
			msg = '用户信息修改成功！'
			console.log(msg)
		else
			ajax_url = "/admin/users"
			msg = '用户信息创建成功,点击列表进行查看!'

		$.post(ajax_url,data,(ret)->
			if ret.success
				flash_notice(msg)
			else
				if ret.value.error_code == "error_5"
					$('#email').parents('.padded').addClass('invalid').removeClass('valid')
					go_top()
				if ret.value.error_code == "error_6"
					$('#mobile').parents('.padded').addClass('invalid').removeClass('valid')
					go_top()
		)		


	$('body').on('click','.tab-nav:last',(e)->
		$.get("/admin/users/new",{},->)		
	)

	$('body').on('click','.search_user',(e)->
		e.preventDefault()
		search_data = $('form.search-user').serialize()
		$.get("/admin/users",search_data,->)
	)

	$('body').on('click','td a.delete-user',(e)->
		curr_tr = $(@).parents('tr')
		cid = $(@).data('cid')
		$.get("/admin/users/delete",{id:cid},(ret)->
			if ret.success
				curr_tr.remove()
		)
	)

	$('body').on('click','.pagination a',->
		unless $(@).hasClass('disabled')
			page   		= $(@).data('page')
			name       	= $(@).data('name')	
			email       = $(@).data('email')
			role		= $(@).data('role')
			position    = $(@).data('position')
			company     = $(@).data('company')
			city        = $(@).data('city')
			interest    = $(@).data('interest')
			creater     = $(@).data('creater')
			status      = $(@).data('status')
			start       = $(@).data('start')
			end         = $(@).data('end')

			g_data = {page:page,name:name,email:email,role:role,position:position,company:company,city:city,interest:interest,creater:creater,status:status,start:start,end:end}
			if page
				$.get("/admin/users",g_data,->)
	)


	$('body').on('focusout','form.new-user #email,#mobile',(e)->
		check_exist($(@))
	)


	$('body').on('focus','form.new-user input',(e)->
		$(@).parents('.padded').removeClass('invalid').removeClass('valid')
	)


	$('body').on('click','form.new-user .info-submit',(e)->
		$obj = $(@)
		e.preventDefault()
		check_presense($obj)
	)



	$('body').on('click','a.edit-user',(e)->
		cid = $(@).attr('id')
		$.get("/admin/users/#{cid}/edit",{},(ret)->)
	)









)