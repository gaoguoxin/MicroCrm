(function() {
  $(function() {
    var delay, flash_notice, remove_notice;
    delay = function(ms, func) {
      return setTimeout(func, ms);
    };
    flash_notice = function(msg) {
      $('.flash-notice').text(msg).addClass('animated bounceInRight').show();
      $("html, body").animate({
        scrollTop: 0
      }, 500);
      return delay(2000, function() {
        return window.location.reload();
      });
    };
    return remove_notice = function() {
      return $('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight');
    };
  });

}).call(this);
