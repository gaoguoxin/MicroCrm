$(->
	show_feeback_box = (cid)->
		$.fancybox.open($('.feedback-box'),{
			padding:0,
			autoSize:true,
			minWidth:1000,
			minHeight:600,
			# scrolling:no,
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
				$('.feedback-box .content table tbody').html('')
				get_feed_info(cid)
		})		

	get_feed_info =(cid)->
		$.get('/manager/feedbacks/get_feed_info',{cid:cid,},(ret)->
			if ret.success
				$.each(ret.value,(k,v)->
					tr = "<tr><td>#{v.uname}</td><td>#{v.q_1}分</td><td>#{v.q_2}分</td><td>#{v.q_3}分</td><td>#{v.q_4}分</td><td>#{v.q_5}分</td><td>#{v.tot}分</td></tr>"
					$('.feedback-box .content table tbody').append(tr)
				)
		)		


	$('body').on('click','a.show_feedback',->
		cid = $(@).data('id')
		show_feeback_box(cid)
	)


	$('body').on('click','button.close-btn',->
		$.fancybox.close()
	)
)