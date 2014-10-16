#=require jquery.timepicker.min
$(->

	bottom_left_height  = $('.bottom-left').height()
	bottom_right_height = $('.bottom-right .right-cont').height()
	if bottom_left_height > bottom_right_height
		$('.bottom-right .right-cont').height(bottom_left_height)
	$("#search_start,#search_end").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})	
	$("#course_start_date,#course_end_date").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})
	$('#course_start_time').timepicker({ 'timeFormat': 'h:i A','step': 5 })
	$('#course_end_time').timepicker({ 'timeFormat': 'h:i A','step': 5 })

	
	$('#course_description').ckeditor({})


	open_box = ->
		$.fancybox.open($('.msg-box'),{
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
			afterShow:-> 
				$('#match_content_manager,#match_content_student,#box_notice_content,#box_course_notice_at').focus(->
					$(this).parents('.one').removeClass('invalid')
				)
		})

	match_manager = (obj,v)->
		num = obj.parents('.one').next('.one').find('span.num')
		$.get("/admin/courses/match_manager",{data:v},(ret)->
			if ret.success
				$('#course_manager_condition').val(v)
				num.text(ret.value + '人')
		)	

	match_student = (obj,v)->
		num = obj.parents('.one').next('.one').find('span.num')
		$.get("/admin/courses/match_student",{data:v},(ret)->
			if ret.success
				$('#course_trainee_condition').val(v)
				num.text(ret.value + '人')
		)


	check_msg_info = ->
		going = true
		# $('#match_content_manager,#match_content_student,#box_notice_content,#box_course_notice_at').each(->
		# 	unless $.trim($(@).val()).length > 0
		# 		$(@).closest('.one').addClass('invalid').removeClass('valid')
		# 		going = false
		# )
		$('#match_content_manager,#match_content_student,#box_course_notice_at').each(->
			unless $.trim($(@).val()).length > 0
				$(@).closest('.one').addClass('invalid').removeClass('valid')
				going = false
		)

		submit_info() if going


	submit_info = ->
		$.fancybox.close()
		$('form').submit()


	check_present = ->
		go = true
		publish = parseInt($('#course_status').val())
		$('form.info input,select,textarea').each(->
			unless $(@).attr('id') == 'course_instructor_avatar'
				if $(@).is(":visible")
					if $('#course_charge_category').val() == '1'
						if $.trim($(@).val()).length <= 0 &&  $.inArray($(@).attr('id'),['course_price_level1','course_price_level2','course_price_level3']) < 0
							$(@).parent('.padded').addClass('invalid').removeClass('valid')
							go = false 
							top = $(@).offset().top
							$("html, body").animate({ scrollTop: top }, 500)
							go = false
							return false

					else
						if $.trim($(@).val()).length <= 0
							$(@).parent('.padded').addClass('invalid').removeClass('valid')
							go = false 
							top = $(@).offset().top
							$("html, body").animate({ scrollTop: top }, 500)
							go = false
							return false
		)
		if go 
			if publish == 1
				open_box() # 所有的表单验证通过，并且该课程被设置为发布的时候才会有弹出层
			else
				$('form').submit() # 如果一个课程不是被设置为了发布中，那么不需要填写短息提醒内容，直接提交表单。

	open_proxy_box = (obj)->
		$.fancybox.open($('.proxy-box'),{
			padding:0,
			autoSize:true,
			# scrolling:no,
			minWidth:800,
			minHeight:500,
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
				$('.proxy-box h6').text(obj.parents('td').siblings('td.cname').text())
				$('.proxy-box #proxy_cid').val(obj.data('id'))
				$('.proxy-box .content .checklist').html('')
				$('.proxy-box .multiple_proxy').attr('data-cid',obj.data('id'))


		})		


	generate_proxy_order = (id_arr,cid)->
		$.post('/admin/orders/generate_proxy_order',{uarr:id_arr,cid:cid},(ret)->
			if ret.success
				$('.select-tool').addClass('yellow')
				$('.select-tool button').removeClass('info').addClass('success').text('报名成功')
		)

	$('form.info input,select,textarea').focus(->
		$(@).parent('.padded').removeClass('invalid')
	)

	$('button.submit').click((e)->
		e.preventDefault()
		check_present();

	)

	$('body').on('change','#match_content_manager',->
		m_v = $(@).val()
		match_manager($(@),m_v)
	)

	$('body').on('change','#match_content_student',->
		m_s = $(@).val()
		match_student($(@),m_s)
	)

	$('body').on('keyup','#box_notice_content',->
		v = $(@).val()
		remain = 72 - v.length
		$('i.remain').text(remain)
		$('#course_notice_content').val(v)
	)

	$('body').on('keyup','#box_course_notice_at',->
		notice_at = $(@).val()
		$('#course_notice_at').val(notice_at)
	)

	$('body').on('click','.box_button',->
		check_msg_info()
	)

	$('body').on('click','.pagination a',->
		unless $(@).hasClass('disabled')
			page			= $(@).data('page')
			code			= $(@).data('code')
			name            = $(@).data('name')
			start   	    = $(@).data('start')
			end    		    = $(@).data('end')
			content         = $(@).data('content')
			city            = $(@).data('city')
			status          = $(@).data('status')
			g_data = {page:page,code:code,name:name,start:start,end:end,content:content,city:city,status:status}

			if page
				$.get("/admin/courses",g_data,->)
	)

	$('body').on('click','a.proxy',->
		open_proxy_box($(@))
	)

	$('body').on('click','.multiple_proxy',(e)->
		e.preventDefault()
		$.get("/admin/courses/proxy_search",$('form.proxy-form').serialize(),(ret)->
			$('.proxy-box .content .checklist').html('')
			$.each(ret.value,(k,v)->
				if v.ordered
					$("<li class='turquoise one fourth' data-uid=#{v.uid} data-ordered=1 aria-checked='true'>#{v.name}</li>").appendTo($('.proxy-box .content .checklist'))
				else
					$("<li class='turquoise one fourth' data-uid=#{v.uid} data-ordered=0>#{v.name}</li>").appendTo($('.proxy-box .content .checklist'))
				
			)
		)
	)

	$('body').on('click','.select-tool li',->
		if $(@).attr('aria-checked') == 'true'
			$('.content .checklist li[data-ordered="0"]').attr('aria-checked',true)
		else	
			$('.content .checklist li[data-ordered="0"]').attr('aria-checked',false)
	)

	$('body').on('click','button.multiple_proxy',->
		cid = $(@).data('cid')
		if $('.content .checklist li[aria-checked="true"]').length > 0
			id_arr = []
			$('.content .checklist li[aria-checked="true"]').each(->
				id_arr.push $(@).data('uid')
			)
			if id_arr.length > 0
				generate_proxy_order(id_arr,cid)
	)




)