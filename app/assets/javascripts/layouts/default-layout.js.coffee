$(->
	$('body').on('click','.fa-search',->
		$('form.layout-search').submit()		
	)

	$('body').on('keydown','#search-name',(e)->
		if e.wchich == 13
			$('.fa-search').click()
	)
)