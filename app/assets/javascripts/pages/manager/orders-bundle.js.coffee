$(->
	$("#search_start,#search_end").datepicker({dateFormat: "yy-mm-dd",showAnim:'show'})
	get_employee = (id_arr)->
		$.post('/manager/orders/get_employee',{data:id_arr},(ret)->
			if ret.success
				$.each(ret.value,(k,v)->
					li_before  = "<div class='row'>
						<div class='box one whole success'>
							<div class='two sixths'>(编号)名字:(#{v.c_code})#{v.c_name}</div>
							<div class='one sixth'>城市:#{v.c_city}</div>
							<div class='one sixth'>日期:#{v.c_start}</div>
							<div class='one sixth'>教师:#{v.c_instructor}</div>
							<div class='one sixth'>剩余名额:#{v.c_remain}</div>
						</div>
						<div class='one whole'>
							<div class='row'>
								<ul class='checklist large turquoise'>"


					li_str = ""
					$.each(v.e_arr,(ek,ev)->
						li_str_pre = "<li class='pull-left one third' data-id='#{v.c_id}' data-u=#{ev.e_id}  data-cancel= #{ev.can_cancel} data-enroll=#{ev.e_enroll}" 
						li_str_middle = if ev.e_enroll then " aria-checked='true' " else ''
						# li_str_after = " >#{ev.e_name}/#{ev.e_email}/#{ev.e_mobile}</li>"
						li_str_after = " >#{ev.e_name}</li>"
						li = li_str_pre + li_str_middle + li_str_after
						li_str += li
					)

					li_wraper = "</ul</div></div></div>"

					row = li_before + li_str + li_wraper

					$('.employee-box .content').append(row)
				)
		)


	open_select_box = (id_arr)->
		$.fancybox.open($('.employee-box'),{
			padding:0,
			autoSize:true,
			minWidth:1000,
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
				$('.employee-box .content').html('')
				get_employee(id_arr)
			afterClos:->
				$('.employee-box .multiple_start_button').removeClass('success').addClass('info').text('确定')
		})


	get_order_list = (course_id,opera)->
		$.get('/manager/orders/get_order_list',{id:course_id},(ret)->
			$.each(ret.value,(k,v)->
				tr_pre = "<tr>
				<td class='align-center'>#{v.c_name}</td><td class='align-center'>#{v.u_name}</td><td class='align-center'>#{v.state}</td><td class='align-center'>#{v.status}</td>
				<td class='align-center'>#{v.presence}</td>
				<td class='align-center'>"

				atmp = ""
				if opera
					if v.is_cancel
						atmp += "<a href='javascript:void(0);'>已取消报名</a>"
					else
						if v.can_cancel	
							atmp += "<a href='javascript:void(0);' data-c='#{v.c_id}' data-u='#{v.u_id}' data-id=#{v.oid} class='cancel-order'>取消报名</a>&nbsp;"
						if v.is_check
							if v.check_ok
								atmp += "<a href='javascript:void(0);' data-c='#{v.c_id}' data-u='#{v.u_id}' class='refuse-order'>拒绝报名</a>&nbsp;"
							else
								atmp += "<a href='javascript:void(0);' data-c='#{v.c_id}' data-u='#{v.u_id}' class='check-order'>允许报名</a>&nbsp;"
						else
							atmp += "<a href='javascript:void(0);' data-c='#{v.c_id}' data-u='#{v.u_id}' class='check-order'>允许报名</a><br/>"
							atmp += "<a href='javascript:void(0);' data-c='#{v.c_id}' data-u='#{v.u_id}' class='refuse-order'>拒绝报名</a>"
				else
					if v.is_cancel
						atmp += "<a href='javascript:void(0);'>已取消报名</a>"
					else
						if v.check_ok
							atmp += "<a href='javascript:void(0);'>已允许报名</a>"
						else
							atmp += "<a href='javascript:void(0);'>已拒绝报名</a>"

				tr_after = "</td></tr>"
				tr = tr_pre + atmp + tr_after
				$('.order-list table tbody').append(tr)


			)
		)

	open_order_list = (course_id,opera)->
		$.fancybox.open($('.order-list'),{
			padding:0,
			autoSize:true,
			minWidth:1000,
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
				$('.order-list .content table tbody').html('')
				get_order_list(course_id,opera)
		})		



	check_order = (cid,uid,type,obj)->
		$.get('/manager/orders/check',{cid:cid,uid:uid,type:type},(ret)->
			if ret.success
				obj.removeAttr('class')
				if type == 'refuse'
					obj.text('已拒绝')
				else
					obj.text('已同意')
		)

	generate_order = (cu_arr)->
		$.post('/manager/orders',data:cu_arr,(ret)->
			if ret.success
				$.fancybox.close()
				$('.employee-box .multiple_start_button').removeClass('info').addClass('success').text('恭喜您,报名成功,请等待系统教务审核！')
				window.location.href = '/manager/orders?t=w'
		)		



	$('body').on('click','.search_course',(e)->
		e.preventDefault()
		search_data = $('form.search-course').serialize()
		$.get("/manager/orders",search_data,->)
	)


	$('body').on('click','.pagination a',->
		unless $(@).hasClass('disabled')
			page   		= $(@).data('page')
			name       	= $(@).data('name')	
			code        = $(@).data('code')
			content     = $(@).data('content')
			city        = $(@).data('city')
			start       = $(@).data('start')
			end         = $(@).data('end')

			g_data = {page:page,name:name,code:code,content:content,city:city,start:start,end:end}
			if page
				$.get("/manager/orders",g_data,->)
	)




	$('body').on('click','table tr th .checklist li',->
		if $(@).attr('aria-checked') == 'true'
			$('table tr td li').attr('aria-checked',true)
		else	
			$('table tr td li').attr('aria-checked',false)
	)	

	$('body').on('click','button.start',->
		if $('table tr td li[aria-checked="true"]').length > 0
			id_arr = []
			$('table tr td li[aria-checked="true"]').each(->
				id_arr.push $(@).data('id')
			)
			if id_arr.length > 0
				open_select_box(id_arr)

	)

	$('body').on('click','.employee-box li',(e)->
		if $(@).data('cancel') == false && $(@).data('enroll') == true
			$(@).attr('aria-checked',true) # 如果某个报名想取消，且当前时间距离开课已经小于3天，则不允许取消，永远是勾选状态
	)

	$('body').on('click','.employee-box .multiple_start_button',->
		cu_arr = []
		$('.employee-box ul li').each(->
			ty = if $(@).attr('aria-checked') ==  'true' then 'enroll' else 'cancel'  #  标示当前是取消还是报名
			cu_arr.push {c_id:$(@).data('id'),u_id:$(@).data('u'),type:ty}
		)
		generate_order(cu_arr)
	)


	$('body').on('click','a.show-order',->
		course_id = $(@).data('id')
		opera = $(@).data('opera')
		open_order_list(course_id,opera)
	)

	$('body').on('click','a.refuse-order,a.check-order',->
		cid = $(@).data('c')
		uid = $(@).data('u')
		if $(@).hasClass('refuse-order')
			type = 'refuse'
		else
			type = 'check'

		check_order(cid,uid,type,$(@))
	)


	$('body').on('click','a.cancel-order',->
		$obj = $(@)
		oid = $(@).data('id')	
		$.get('/manager/orders/cancel',{id:oid},(ret)->
			if ret.success
				$obj.removeAttr('class').text('已取消报名')
		)		

	)

	$('body').on('click','button.close-box',->
		$.fancybox.close()
	)



)