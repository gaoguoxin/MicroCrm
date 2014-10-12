(function() {
  $(function() {
    $('body').on('click', 'a.origin', function() {
      if ($(this).hasClass('city')) {
        $('.city-select').removeClass('animated bounceOutLeft').show();
      }
      if ($(this).hasClass('type')) {
        $('.type-select').removeClass('animated bounceOutLeft').show();
      }
      if ($(this).hasClass('start')) {
        return $('.start-select').removeClass('animated bounceOutLeft').show();
      }
    });
    $('body').on('click', '.select-container a', function() {
      var parent, select;
      parent = $(this).parents('.select-container');
      select = $(this).data('select');
      if ($(this).hasClass('city')) {
        $('input[name=city]').val(select);
        $('strong.city').text(select);
      }
      if ($(this).hasClass('type')) {
        $('input[name=type]').val(select);
        $('strong.type').text(select);
      }
      return parent.addClass('animated bounceOutLeft').hide();
    });
    return $('body').on('click', '.start-select button, .end-select button', function() {
      var start;
      if ($(this).parents('.start-select').length > 0) {
        $('input[name=start_date]').val();
        start = $('input[name=start_date]').val();
        if (start.length <= 0) {
          start = '开始日期';
        }
        $('strong.start').text(start);
        $('.select-container.start-select').css({
          display: 'none'
        });
      }
      if ($(this).parents('.end-select').length > 0) {
        $('input[name=endt_date]').val();
        $('strong.end').text($('input[name=end_date]').val());
        return $('.select-container.end-select').hide();
      }
    });
  });

}).call(this);
