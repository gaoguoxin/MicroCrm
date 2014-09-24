#=require regex
$(->
	#$("#search_start,#search_end").datepicker()
	$("#search_start,#search_end").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})

	delay = (ms, func) -> setTimeout func, ms

	flash_notice = (msg)->
		$('.flash-notice').text(msg).addClass('animated bounceInRight').show()
		$("html, body").animate({ scrollTop: 0 }, 500)
		delay 2000, ->  window.location.reload()

	check_presense = (obj)->
		name = $.trim($('#name').val())
		manager = $.trim($('#manager').val())
		if name.length <= 0
			$('#name').parents('.padded').addClass('invalid').removeClass('valid')
			$("html, body").animate({ scrollTop: 0 }, 500)
			return

		if name.indexOf('其他') < 0
			if manager.length <= 0
				$('#manager').parents('.padded').addClass('invalid').removeClass('valid')
				$("html, body").animate({ scrollTop: 0 }, 500)
				return
			else
				$('.invalid').removeClass('invalid') 

		submit_company_info(obj)

	remove_notice = ->
		$('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight')


	submit_company_info = (obj)->
		data = $('form.new-company').serialize()
		if obj.hasClass('upd')
			ajax_url = "/admin/companies/update_info"
			msg = '单位信息修改成功！'
		else
			ajax_url = "/admin/companies"
			msg = '新单位创建成功,点击列表进行查看!'

		$.post(ajax_url,data,(ret)->
			if ret.success
				flash_notice(msg)
		)		


	$('body').on('click','.tab-nav:last',(e)->
		$.get("/admin/companies/new",{},->)		
	)

	$('body').on('click','.search-submit',(e)->
		e.preventDefault()
		search_data = $('form.search-form').serialize()
		$.get("/admin/companies",search_data,->)
	)

	$('body').on('click','td a.delete-company',(e)->
		curr_tr = $(@).parents('tr')
		cid = $(@).data('cid')
		$.get("/admin/companies/delete",{id:cid},(ret)->
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
			search_name    = $(@).data('search_name')
			search_account = $(@).data('search_account')
			g_data = {page:page,search_status:status,search_level:level,search_type:type,search_name:search_name,search_account:search_account}
			if page
				$.get("/admin/companies",g_data,->)
	)

	$('body').on('focus','form.new-company input',(e)->
		$(@).parents('.padded').removeClass('invalid').removeClass('valid')
	)

	$('body').on('click','.search-manager',(e)->
		$this = $(@)
		manager = $.trim($('#manager').val())
		if $.regex.isMobile(manager) or $.regex.isEmail(manager)
			data = {account:manager}
			$.get("/admin/companies/search_manager",data,(ret)->
				if ret.success
					if ret.value
						$this.parents('.padded').addClass('valid')
						$this.text('匹配成功!')
					else
						$this.parents('.padded').addClass('invalid')
						$this.text('不存在，创建?')		
			)
		else
			unless $('form.new-company #name').val().indexOf?('其他') >= 0
				$(@).parents('.padded').addClass('invalid')		
	)


	$('body').on('keydown','form.new-company #manager',(e)->
		if e.which == 9
			$('.search-manager').click()	
	)

	
	$('body').on('focusout','form.new-company #manager',(e)->
		$('.search-manager').click();
	)


	$('body').on('click','form.new-company .info-submit',(e)->
		$obj = $(@)
		e.preventDefault()
		check_presense($obj)
	)


	$('body').on('keydown','form.new-company #description',(e)->
		if e.which == 13
			$('form.new-company .info-submit').click()
	)


	$('body').on('click','a.edit-company',(e)->
		cid = $(@).attr('id')
		$.get("/admin/companies/#{cid}/edit",{},(ret)->)
	)

)


