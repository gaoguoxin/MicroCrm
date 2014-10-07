
$(->
	$("#search_start,#search_end").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})
	

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
		$.get('/admin/feedbacks/get_feed_info',{cid:cid},(ret)->
			if ret.success
				$.each(ret.value,(k,v)->
					tr = "<tr>
						<td>#{v.uname}</td>
						<td class='point'  data-uid=#{v.uid} data-cid=#{v.cid} data-q='question_1' data-id=#{v.f_id} ><span>#{v.q_1}分</span><input type='number' name='point' maxlength=2 value=#{v.q_1}></td>
						<td class='point'  data-uid=#{v.uid} data-cid=#{v.cid} data-q='question_2' data-id=#{v.f_id} ><span>#{v.q_2}分</span><input type='number' name='point' maxlength=2 value=#{v.q_2}></td>
						<td class='point'  data-uid=#{v.uid} data-cid=#{v.cid} data-q='question_3' data-id=#{v.f_id} ><span>#{v.q_3}分</span><input type='number' name='point' maxlength=2 value=#{v.q_3}></td>
						<td class='point'  data-uid=#{v.uid} data-cid=#{v.cid} data-q='question_4' data-id=#{v.f_id} ><span>#{v.q_4}分</span><input type='number' name='point' maxlength=2 value=#{v.q_4}></td>
						<td class='point'  data-uid=#{v.uid} data-cid=#{v.cid} data-q='question_5' data-id=#{v.f_id} ><span>#{v.q_5}分</span><input type='number' name='point' maxlength=2 value=#{v.q_5}></td>
						<td class='tot'>#{v.tot}分</td>
						<td class='status'>#{v.status}</td>
						<td class='check' ><ul class='checklist turquoise large'><li data-uid=#{v.uid} data-cid=#{v.cid} data-id=#{v.f_id} >审核</li></ul></td>	
					</tr>"
					$('.feedback-box .content table tbody').append(tr)
				)
		)		



           



	change_point = (obj)->
		cid = obj.parents('td').data('cid')
		uid = obj.parents('td').data('uid')
		q   = obj.parents('td').data('q')
		p   = obj.val()
		$.post('/admin/feedbacks/change_point',{cid:cid,uid:uid,q:q,p:p},(ret)->
			if ret.success
				obj.val(p).hide().siblings('span').text(p + '分').show()
				obj.parents('tr').find('.tot').text(ret.value + '分')
				obj.parents('tr').find('.status').text('等待审核')
		)		



	check_feedback =(arr,obj)->
		cid = obj.parents('td').data('cid')
		uid = obj.parents('td').data('uid')
		
		if obj.hasClass('pass')
			result = 'pass'
			text = '审核通过'
			r = 'pass'
		else
			result = 'refuse' 	
			text = '审核拒绝'
			r = 'refuse'		
		$.post('/admin/feedbacks/check_feedback',{data:arr,r:r},(ret)->
			if ret.success
				$.each(arr,(k,v)->
					li = $(".checklist li[data-uid='#{v.uid}']")
					td = li.parents('td')
					check_result = td.prev('td')
					if check_result.text() != '尚未反馈'
						check_result.text(text)
				)
		)		 


	$('body').on('click','a.show-feedback',->
		cid = $(@).data('id')
		show_feeback_box(cid)
	)


	$('body').on('click','button.close-btn',->
		$.fancybox.close()
	)

	$('body').on('click','.search-feedbacks',(e)->
		e.preventDefault()
		search_data = $('form.search-form').serialize()
		$.get("/admin/feedbacks",search_data,->)
	)

	$('body').on('click','.pagination a',->
		unless $(@).hasClass('disabled')
			page   		   = $(@).data('page')
			status 		   = $(@).data('status')
			code  		   = $(@).data('code')
			t   		   = $(@).data('t')
			name           = $(@).data('name')
			city           = $(@).data('city')
			content        = $(@).data('content')

			g_data = {page:page,status:status,code:code,t:t,name:name,city:city,content:content}
			if page
				$.get("/admin/feedbacks",g_data,->)
	)


	$('body').on('click','td.point',->
		$(@).find('span').hide().siblings('input').show()
	)

	$('body').on('keydown','td.point input',(e)->
		if e.which == 13
			change_point($(@))
	)

	$('body').on('blur','td.point input',(e)->
		change_point($(@))
	)	


	$('body').on('click','.check-tool .checklist li',->
		if $(@).attr('aria-checked') == 'true'
			$('td.check li').attr('aria-checked',true)
		else	
			$('td.check li').attr('aria-checked',false)
	)


	$('body').on('click','button.pass,button.refuse',->
		if $('td.check li[aria-checked="true"]').length > 0
			id_arr = []
			$('td.check li[aria-checked="true"]').each(->
				id_arr.push {cid:$(@).data('cid'),uid:$(@).data('uid')}
			)
			if id_arr.length > 0
				check_feedback(id_arr,$(@))
	)













)