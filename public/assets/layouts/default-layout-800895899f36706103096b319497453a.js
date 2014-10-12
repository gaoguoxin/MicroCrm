(function() {
  $(function() {
    $('body').on('click', '.fa-search', function() {
      return $('form.layout-search').submit();
    });
    return $('body').on('keydown', '#search-name', function(e) {
      if (e.wchich === 13) {
        return $('.fa-search').click();
      }
    });
  });

}).call(this);
