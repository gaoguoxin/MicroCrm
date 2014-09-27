#=require jquery.timepicker.min
$(->
	$("#course_start_date,#course_end_date").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})
	$('#course_start_time').timepicker({ 'timeFormat': 'h:i A','step': 5 })
	$('#course_end_time').timepicker({ 'timeFormat': 'h:i A','step': 5 })

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
			afterClose:-> 
		})		

	check_present = ->
		#$('#course_name_cn,#course_name_en,#course_code,#course_audience,#course_instructor,#course_instructor_desc,')
		open_box()

	$('button.submit').click((e)->
		e.preventDefault()
		check_present();

	)


)