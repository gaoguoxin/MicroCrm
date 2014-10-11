$(->

	$('body').on('click','.tablist li',->
		href = $(@).attr('href')
		$.get("#{href}",{},->)
	)

	$('body').on('click','td.no-data button',->
		table = $(@).parents('table')
		arr = []
		q1 = table.find('input[name="question_1"]:checked').val()
		arr.push q1 if q1

		q2 = table.find('input[name="question_2"]:checked').val()
		arr.push q2 if q2

		q3 = table.find('input[name="question_3"]:checked').val()
		arr.push q3 if q3

		q4 = table.find('input[name="question_4"]:checked').val()
		arr.push q4 if q4

		q5 = table.find('input[name="question_5"]:checked').val()
		arr.push q5 if q5

		return false if arr.length < 5
		cid = $(@).data('cid')

		if cid
			$.post('/user/feedbacks',{data:arr,c_id:cid},(ret)->
				if ret.success	
					window.location.href = '/user/feedbacks'
			)


	)
)