#=require regex
$(->
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
			console.log(ret)
			if ret.success
				flash_notice(msg)
		)	

	open_search_mannager = (data)->
		$.fancybox.open($('.search_mannager'),{
			padding:0,
			autoSize:true,
			scrolling:no,
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
				$('ul.zero').html('')
				$.get("/admin/companies/search_manager",data,(ret)->
					if ret.success
						if ret.value.length > 0 
							$.each(ret.value,(k,v)->
								str = "<li>
								  <input id='manager_#{k}' type='radio' name='manager' value='#{v._id.$oid}'>
								  <label for='manager_#{k}' class='inline'>#{v.name}</label>
								</li>"
								$('ul.zero').append(str)
							)
						else
							$('ul.zero').append("<li class='align-center'>没有查到相应用户</li>")	
				)
		})			


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
			search_name    = $(@).data('name')
			search_account = $(@).data('account')
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
		if manager.length > 0 
			data = {account:manager}
			open_search_mannager(data)
		else
			unless $('form.new-company #name').val().indexOf?('其他') >= 0
				$(@).parents('.padded').addClass('invalid')	
	)

	$('body').on('click','.select-manager-btn',(e)->
		e.preventDefault()
		manager_id = $('input[name="manager"]:checked').val()
		if manager_id
			$('#manager').val(manager_id)
		else
			$('#manager').val('')

		$.fancybox.close()	
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


