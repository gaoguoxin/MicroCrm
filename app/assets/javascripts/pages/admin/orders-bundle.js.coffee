$(->
	$("#search_start,#search_end").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})

	$('body').on('click','.search-submit',(e)->
		e.preventDefault()
		search_data = $('form.search-orders').serialize()
		$.get("/admin/orders",search_data,->)
	)

	$('body').on('click','.pagination a',->
		unless $(@).hasClass('disabled')
			page			= $(@).data('page')
			code			= $(@).data('code')
			name            = $(@).data('name')
			start   	    = $(@).data('start')
			end    		    = $(@).data('end')
			state           = $(@).data('state')
			status          = $(@).data('status')
			cancel          = $(@).data('cancel')
			content         = $(@).data('content')
			city            = $(@).data('city')
			company         = $(@).data('company')
			t               = $(@).data('t')
			g_data = {page:page,code:code,name:name,start:start,end:end,state:state,status:status,cancel:cancel,content:content,city:city,company:company,t:t}

			if page
				$.get("/admin/orders",g_data,->)
	)


	$('body').on('click','.check-tool .checklist li',->
		if $(@).attr('aria-checked') == 'true'
			$('td.opera li').attr('aria-checked',true)
		else	
			$('td.opera li').attr('aria-checked',false)
	)


	$('body').on('click','.check-tool button',->
		unless $(@).hasClass('disabled')
			if $('td.opera .checklist li[aria-checked="true"]').length > 0
				id_arr = []
				$('td.opera .checklist li[aria-checked="true"]').each(->
					id_arr.push $(@).data('id')
				)
				if id_arr.length > 0
					if $(@).hasClass('absent')
						#缺席
						make_attend(id_arr,'absent')
					if $(@).hasClass('attend')
						#出席
						make_attend(id_arr,'attend')
					if $(@).hasClass('allow')
						#允许
						check_order(id_arr,'allow')
					if $(@).hasClass('refuse')
						#拒绝
						check_order(id_arr,'refuse')
					if $(@).hasClass('cancel')
						#取消
						confirm_cancel(id_arr)
					$(@).addClass('disabled')			
	)	


	$('body').on('click','button.cancel-operation',->
		$('.checklist li').attr('aria-checked',false)
		$.fancybox.close()
	)

	$('body').on('click','button.sure-operation',->
		cancel_order(window.id_arr)
		$.fancybox.close()
	)	


	confirm_cancel = (id_arr)->
		$.fancybox.open($('.confirm-box'),{
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
				window.id_arr = id_arr
			afterClose:->
				window.id_arr = ''
		})			

	make_attend = (arr,type)->
		$.post('/admin/orders/make_attend',{data:arr,type:type},(ret)->
			if ret.success
				if type == 'absent'
					txt = '缺席'
				else
					txt = '出席'
				$.each(arr,(k,v)->
					$("li[data-id='#{v}']").parents('td').prev('td').text(txt)
				)
		)


	check_order = (arr,type)->
		$.post('/admin/orders/check_order',{data:arr,type:type},(ret)->
			if ret.success
				if type == 'allow'
					txt = '审核通过'
				else
					txt = '审核拒绝'				
				$.each(arr,(k,v)->
					$("li[data-id='#{v}']").parents('td').siblings('td.state').text(txt)
				)
		)

	cancel_order = (arr)->
		$.post('/admin/orders/cancel_order',{data:arr},(ret)->
			if ret.success
				$.each(arr,(k,v)->
					$("li[data-id='#{v}']").parents('td').siblings('td.cancel').text('取消')
				)
		)				


)