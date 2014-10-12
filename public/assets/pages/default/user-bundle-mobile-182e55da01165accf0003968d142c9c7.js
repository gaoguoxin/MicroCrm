(function() {
  $(function() {
    return $('body').on('click', 'button.info-sub', function(e) {
      e.preventDefault();
      return $.post("/users/update_info", $('form').serialize(), function(ret) {
        return window.location.reload();
      });
    });
  });

}).call(this);
