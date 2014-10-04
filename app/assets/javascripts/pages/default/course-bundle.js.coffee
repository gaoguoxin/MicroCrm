$(->
	$('body').on('click','button.feed-btn',->
		arr = []
		q1 = $('input[name="question_1"]:checked').val()
		arr.push q1 if q1

		q2 = $('input[name="question_2"]:checked').val()
		arr.push q2 if q2

		q3 = $('input[name="question_3"]:checked').val()
		arr.push q3 if q3

		q4 = $('input[name="question_4"]:checked').val()
		arr.push q4 if q4

		q5 = $('input[name="question_5"]:checked').val()
		arr.push q5 if q5

		return false if arr.length < 5
		unless window.u_id.length > 0
			window.location.href = "/login?ref=/courses/#{window.c_id}"
			return false
		$.post('/feedbacks',{data:arr,c_id:window.c_id},(ret)->
			if ret.success	
				window.location.href = '/feedbacks?t=p'
			else
				console.log(ret)
				$('button.feed-btn').text('无权反馈!').css({background:'#e74c3c'})
		)
	)
)