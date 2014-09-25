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
		$.post("/admin/users/check_exist",data,(ret)->
			if ret.success
				if ret.value
					obj.parents('.padded').addClass('invalid').removeClass('valid')
				else
					obj.parents('.padded').addClass('valid').removeClass('invalid')
	
		)

	check_presense = (obj)->
		submit = true
		$('#name,#email,#mobile,#password').each(->
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
			page   		   = $(@).data('page')
			status 		   = $(@).data('status')
			level  		   = $(@).data('level')
			type   		   = $(@).data('type')
			search_name    = $(@).data('name')
			search_account = $(@).data('account')
			g_data = {page:page,search_status:status,search_level:level,search_type:type,search_name:search_name,search_account:search_account}
			if page
				$.get("/admin/companies",g_data,->)
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