$(->
	delay = (ms, func) -> setTimeout func, ms

	flash_notice = (msg)->
		$('.flash-notice').text(msg).addClass('animated bounceInRight').show()
		$("html, body").animate({ scrollTop: 0 }, 500)
		delay 2000, ->  window.location.reload()

	remove_notice = ->
		$('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight')


)