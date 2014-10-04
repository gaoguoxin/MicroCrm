$(->
	$('body').on('click','a.origin',->
		if  $(@).hasClass('city')
			$('.city-select').removeClass('animated bounceOutLeft').show();
		if  $(@).hasClass('type')
			$('.type-select').removeClass('animated bounceOutLeft').show();		
		if  $(@).hasClass('start')
			$('.start-select').removeClass('animated bounceOutLeft').show();						
	)

	$('body').on('click','.select-container a',->
		parent = $(@).parents('.select-container')
		select = $(@).data('select')
		if $(@).hasClass('city')
			$('input[name=city]').val(select)
			$('strong.city').text(select)
		if $(@).hasClass('type')
			$('input[name=type]').val(select)
			$('strong.type').text(select)		
		parent.addClass('animated bounceOutLeft').hide()
	)

	$('body').on('click','.start-select button, .end-select button',->
		if $(@).parents('.start-select').length > 0
			$('input[name=start_date]').val()
			start = $('input[name=start_date]').val()
			start = '开始日期' if start.length <= 0 
			$('strong.start').text(start)
			$('.select-container.start-select').css({display:'none'})
		if $(@).parents('.end-select').length > 0
			$('input[name=endt_date]').val()
			$('strong.end').text($('input[name=end_date]').val())
			$('.select-container.end-select').hide()
	)

	# $('body').on('click','.search-btn', ->
	# 	city = $('strong.city').text()
	# 	if /^选择城市$/.test(city)
	# 		city = ''
	# 	type = $('strong.type').text()
	# 	if /^课程类型$/.test(type)
	# 		type = ''

	# 	start = $('input[name=start_date]').val()
	# 	end   = $('input[name=end_date]').val()
	# 	key   = $('input[name=keyword]').val()
	# 	data = {city:city,type:type,start:start,end:end,key:key}

	# 	$.get('/courses/do_search',data,->)
	# )

)