#=require jquery.timepicker.min
$(->
	$("#course_start_date,#course_end_date").datepicker({dateFormat: "yy-mm-dd",showAnim:'show',minDate:0})
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
		$('#match_content_manager,#match_content_student,#box_notice_content,#box_course_notice_at').each(->
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
		$('form.new_course input,select,textarea').each(->
			unless $(@).attr('id') == 'course_instructor_avatar'
				if $(@).is(":visible")
					if $.trim($(@).val()).length <= 0
						$(@).parent('.padded').addClass('invalid').removeClass('valid')
						go = false 
						top = $(@).offset().top
						$("html, body").animate({ scrollTop: top }, 500)
						go = false
						return false
		)
		open_box() if go

	$('form.new_course input,select,textarea').focus(->
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







)