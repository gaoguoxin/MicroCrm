$(->
	$('body').on('focus',"#date_paid,#finished_at", ->
    	$(@).datepicker({dateFormat: "yy-mm-dd",showAnim:'show'});
	)

	delay = (ms, func) -> setTimeout func, ms

	flash_notice = (msg)->
		$('.flash-notice').text(msg).addClass('animated bounceInRight').show()
		$("html, body").animate({ scrollTop: 0 }, 500)
		delay 2000, ->  window.location.reload()

	check_serial = (obj)->
		serial_number = $.trim($('#serial_number').val())
		$.get("/admin/cards/check_serial",{num:serial_number},(ret)->
			if ret.success && ret.value
				$('#serial_number').parent('.padded').addClass('invalid').removeClass('valid')
				$("html, body").animate({ scrollTop: 300 }, 500)
			else
				submit_card_info(obj)
		)

	check_presense = (obj)->
		serial_number = $.trim($('#serial_number').val())
		quantity_purchased = $.trim($('#quantity_purchased').val())
		amount_payable = $.trim($('#amount_payable').val())
		submit = true
		$('#serial_number,#quantity_purchased,#amount_payable').each(->
			v = $.trim($(@).val())
			if v.length <= 0
				$(@).parents('.padded').addClass('invalid').removeClass('valid')
				$("html, body").animate({ scrollTop: 300 }, 500)
				submit = false
				return 
		)
		check_serial(obj) if submit

	remove_notice = ->
		$('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight')


	submit_card_info = (obj)->
		data = $('form.new-card').serialize()
		if obj.hasClass('upd')
			ajax_url = "/admin/cards/update_info"
			msg = '学习卡单位信息修改成功！'
		else
			ajax_url = "/admin/cards"
			msg = '新学习卡创建成功,点击列表进行查看!'

		$.post(ajax_url,data,(ret)->
			if ret.success
				flash_notice(msg)
		)		


	$('body').on('click','.tab-nav:last',(e)->
		$.get("/admin/cards/new",{},->)		
	)

	$('body').on('click','.search_card ',(e)->
		e.preventDefault()
		search_data = $('form.search-card').serialize()
		$.get("/admin/cards",search_data,->)
	)

	$('body').on('click','td a.delete-card',(e)->
		curr_tr = $(@).parents('tr')
		cid = $(@).data('cid')
		$.get("/admin/cards/delete",{id:cid},(ret)->
			if ret.success
				curr_tr.remove()
		)
	)

	$('body').on('click','.pagination a',->
		unless $(@).hasClass('disabled')
			page   		   = $(@).data('page')
			serial 		   = $(@).data('serial')
			company  		   = $(@).data('company')
			receipt   		   = $(@).data('receipt')
			buyer    = $(@).data('buyer')
			mobile = $(@).data('mobile')
			status = $(@).data('status')
			type   = $(@).data('type')
			exec   = $(@).data('exec')

			g_data = {page:page,serial:serial,company:company,receipt:receipt,buyer:buyer,mobile:mobile,status:status,type:type,exec:exec}
			if page
				$.get("/admin/cards",g_data,->)
	)

	$('body').on('focus','form.new-card input',(e)->
		$(@).parents('.padded').removeClass('invalid').removeClass('valid')
	)



	$('body').on('click','form.new-card .info-submit',(e)->
		$obj = $(@)
		e.preventDefault()
		check_presense($obj)
	)


	$('body').on('keydown','form.new-card #post_address',(e)->
		if e.which == 13
			$('form.new-card .info-submit').click()
	)


	$('body').on('click','a.edit-card',(e)->
		cid = $(@).attr('id')
		$.get("/admin/cards/#{cid}/edit",{},(ret)->)
	)

)


