(function() {
  $(function() {
    var generate_order;
    $('body').on('click', '.select-tool .checklist li', function() {
      if ($(this).attr('aria-checked') === 'true') {
        return $('.select-list li').attr('aria-checked', true);
      } else {
        return $('.select-list li').attr('aria-checked', false);
      }
    });
    $('body').on('click', '.multip-start', function() {
      var id_arr;
      if ($('.select-list li[aria-checked="true"]').length > 0) {
        id_arr = [];
        $('.select-list li[aria-checked="true"]').each(function() {
          return id_arr.push($(this).data('id'));
        });
        if (id_arr.length > 0) {
          return generate_order(id_arr);
        }
      }
    });
    $('body').on('click', 'button.start', function() {
      var id;
      id = $(this).data('id');
      return generate_order([id]);
    });
    $('body').on('click', 'button.feedback', function() {
      var h;
      h = $(this).data('id');
      return window.open("/courses/" + h);
    });
    return generate_order = function(data) {
      return $.post('/orders', {
        data: data
      }, function(ret) {
        if (ret.success) {
          if (ret.value === false) {
            return window.location.href = '/login';
          } else {
            return window.location.href = '/orders?w=true';
          }
        }
      });
    };
  });

}).call(this);
