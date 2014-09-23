#=require regex
$(->


	delay = (ms, func) -> setTimeout func, ms

	flash_notice = ->
		$('.flash-notice').addClass('animated bounceInRight').show()
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
		else
			ajax_url = "/admin/companies"

		$.post(ajax_url,data,(ret)->
			if ret.success
				flash_notice()
		)		

	$('form.new-company input').focus(->
		$(@).parents('.padded').removeClass('invalid').removeClass('valid')
	)

	$('.search-manager').click(->
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

	$('form.new-company #manager').keydown((e)->
		if e.which == 9
			$('.search-manager').click();
	)

	$('form.new-company #manager').focusout((e)->
		$('.search-manager').click();
	)	

	$('form.new-company .info-submit').bind('click',(e)->
		$obj = $(@)
		e.preventDefault()
		check_presense($obj)
	)


	$('form.new-company #description').keydown((e)->
		if e.which == 13
			$('form.new-company .info-submit').click()
	)

	$('a.edit-company').click(->
		cid = $(@).attr('id')
		$.get("/admin/companies/#{cid}/edit",{},(ret)->)		
	)

)


