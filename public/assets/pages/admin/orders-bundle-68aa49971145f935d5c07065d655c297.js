(function() {
  $(function() {
    var cancel_order, check_order, confirm_cancel, make_attend;
    $("#search_start,#search_end").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
    });
    $('body').on('click', '.search-submit', function(e) {
      var search_data;
      e.preventDefault();
      search_data = $('form.search-orders').serialize();
      return $.get("/admin/orders", search_data, function() {});
    });
    $('body').on('click', '.pagination a', function() {
      var cancel, city, code, company, content, end, g_data, name, page, start, state, status, t;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        code = $(this).data('code');
        name = $(this).data('name');
        start = $(this).data('start');
        end = $(this).data('end');
        state = $(this).data('state');
        status = $(this).data('status');
        cancel = $(this).data('cancel');
        content = $(this).data('content');
        city = $(this).data('city');
        company = $(this).data('company');
        t = $(this).data('t');
        g_data = {
          page: page,
          code: code,
          name: name,
          start: start,
          end: end,
          state: state,
          status: status,
          cancel: cancel,
          content: content,
          city: city,
          company: company,
          t: t
        };
        if (page) {
          return $.get("/admin/orders", g_data, function() {});
        }
      }
    });
    $('body').on('click', '.check-tool .checklist li', function() {
      if ($(this).attr('aria-checked') === 'true') {
        return $('td.opera li').attr('aria-checked', true);
      } else {
        return $('td.opera li').attr('aria-checked', false);
      }
    });
    $('body').on('click', '.check-tool button', function() {
      var id_arr;
      if (!$(this).hasClass('disabled')) {
        if ($('td.opera .checklist li[aria-checked="true"]').length > 0) {
          id_arr = [];
          $('td.opera .checklist li[aria-checked="true"]').each(function() {
            return id_arr.push($(this).data('id'));
          });
          if (id_arr.length > 0) {
            if ($(this).hasClass('absent')) {
              make_attend(id_arr, 'absent');
            }
            if ($(this).hasClass('attend')) {
              make_attend(id_arr, 'attend');
            }
            if ($(this).hasClass('allow')) {
              check_order(id_arr, 'allow');
            }
            if ($(this).hasClass('refuse')) {
              check_order(id_arr, 'refuse');
            }
            if ($(this).hasClass('cancel')) {
              confirm_cancel(id_arr);
            }
            return $(this).addClass('disabled');
          }
        }
      }
    });
    $('body').on('click', 'button.cancel-operation', function() {
      $('.checklist li').attr('aria-checked', false);
      return $.fancybox.close();
    });
    $('body').on('click', 'button.sure-operation', function() {
      cancel_order(window.id_arr);
      return $.fancybox.close();
    });
    confirm_cancel = function(id_arr) {
      return $.fancybox.open($('.confirm-box'), {
        padding: 0,
        autoSize: true,
        scrolling: false,
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
          return window.id_arr = id_arr;
        },
        afterClose: function() {
          return window.id_arr = '';
        }
      });
    };
    make_attend = function(arr, type) {
      return $.post('/admin/orders/make_attend', {
        data: arr,
        type: type
      }, function(ret) {
        var txt;
        if (ret.success) {
          if (type === 'absent') {
            txt = '缺席';
          } else {
            txt = '出席';
          }
          return $.each(arr, function(k, v) {
            return $("li[data-id='" + v + "']").parents('td').prev('td').text(txt);
          });
        }
      });
    };
    check_order = function(arr, type) {
      return $.post('/admin/orders/check_order', {
        data: arr,
        type: type
      }, function(ret) {
        var txt;
        if (ret.success) {
          if (type === 'allow') {
            txt = '审核通过';
          } else {
            txt = '审核拒绝';
          }
          return $.each(arr, function(k, v) {
            return $("li[data-id='" + v + "']").parents('td').siblings('td.state').text(txt);
          });
        }
      });
    };
    return cancel_order = function(arr) {
      return $.post('/admin/orders/cancel_order', {
        data: arr
      }, function(ret) {
        if (ret.success) {
          return $.each(arr, function(k, v) {
            return $("li[data-id='" + v + "']").parents('td').siblings('td.cancel').text('取消');
          });
        }
      });
    };
  });

}).call(this);
