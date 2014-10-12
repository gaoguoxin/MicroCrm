(function() {
  $(function() {
    var open_confirm_box;
    $('body').on('click', '.tablist li', function() {
      var href;
      href = $(this).attr('href');
      return $.get("" + href, {}, function() {});
    });
    $('body').on('click', '.sure-operation', function() {
      var oid;
      oid = $(this).data('oid');
      return $.get("/user/orders/" + oid + "/cancel", {}, function(ret) {
        if (ret.success) {
          return $('a[data-id="#{oid}"]').parents('tr').remove();
        }
      });
    });
    return open_confirm_box = function(obj) {
      return $.fancybox.open($('.confirm-box'), {
        padding: 0,
        autoSize: true,
        scrolling: false,
        minWidth: 300,
        openEffect: 'none',
        closeEffect: 'none',
        helpers: {
          overlay: {
            locked: false,
            closeClick: false,
            css: {
              'background': 'rgba(51, 51, 51, 0.2)'
            }
          }
        },
        beforeShow: function() {
          return $('.sure-operation').attr('data-oid', obj.data('id'));
        },
        afterClose: function() {}
      });
    };
  });

}).call(this);
