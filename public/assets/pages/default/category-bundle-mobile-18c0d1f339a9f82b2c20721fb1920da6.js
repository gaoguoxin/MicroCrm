(function() {
  $(function() {
    return $('body').on('click', '.multip-start', function() {
      var id_arr;
      id_arr = [];
      $('li[aria-checked=true]').each(function() {
        return id_arr.push($(this).data('id'));
      });
      if (id_arr.length > 0) {
        return $.post('/orders', {
          data: id_arr
        }, function(ret) {
          if (ret.success) {
            if (ret.value === false) {
              return window.location.href = '/login';
            } else {
              return window.location.href = '/orders?w=true';
            }
          }
        });
      }
    });
  });

}).call(this);
