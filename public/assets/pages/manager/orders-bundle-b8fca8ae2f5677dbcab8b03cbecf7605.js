(function() {
  $(function() {
    var check_order, generate_order, get_employee, get_order_list, open_order_list, open_select_box;
    $("#search_start,#search_end").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
    });
    get_employee = function(id_arr) {
      return $.post('/manager/orders/get_employee', {
        data: id_arr
      }, function(ret) {
        if (ret.success) {
          return $.each(ret.value, function(k, v) {
            var li_before, li_str, li_wraper, row;
            li_before = "<div class='row'> <div class='box one whole success'> <div class='two sixths'>(编号)名字:(" + v.c_code + ")" + v.c_name + "</div> <div class='one sixth'>城市:" + v.c_city + "</div> <div class='one sixth'>日期:" + v.c_start + "</div> <div class='one sixth'>教师:" + v.c_instructor + "</div> <div class='one sixth'>剩余名额:" + v.c_remain + "</div> </div> <div class='one whole'> <div class='row'> <ul class='checklist large turquoise'>";
            li_str = "";
            $.each(v.e_arr, function(ek, ev) {
              var li, li_str_after, li_str_middle, li_str_pre;
              li_str_pre = "<li class='pull-left one third' data-id='" + v.c_id + "' data-u=" + ev.e_id + "  data-cancel= " + ev.can_cancel + " data-enroll=" + ev.e_enroll;
              li_str_middle = ev.e_enroll ? " aria-checked='true' " : '';
              li_str_after = " >" + ev.e_name + "</li>";
              li = li_str_pre + li_str_middle + li_str_after;
              return li_str += li;
            });
            li_wraper = "</ul</div></div></div>";
            row = li_before + li_str + li_wraper;
            return $('.employee-box .content').append(row);
          });
        }
      });
    };
    open_select_box = function(id_arr) {
      return $.fancybox.open($('.employee-box'), {
        padding: 0,
        autoSize: true,
        minWidth: 1000,
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
          $('.employee-box .content').html('');
          return get_employee(id_arr);
        },
        afterClos: function() {
          return $('.employee-box .multiple_start_button').removeClass('success').addClass('info').text('确定');
        }
      });
    };
    get_order_list = function(course_id, opera) {
      return $.get('/manager/orders/get_order_list', {
        id: course_id
      }, function(ret) {
        return $.each(ret.value, function(k, v) {
          var atmp, tr, tr_after, tr_pre;
          tr_pre = "<tr> <td class='align-center'>" + v.c_name + "</td><td class='align-center'>" + v.u_name + "</td><td class='align-center'>" + v.state + "</td><td class='align-center'>" + v.status + "</td> <td class='align-center'>" + v.presence + "</td> <td class='align-center'>";
          atmp = "";
          if (opera) {
            if (v.is_cancel) {
              atmp += "<a href='javascript:void(0);'>已取消报名</a>";
            } else {
              if (v.can_cancel) {
                atmp += "<a href='javascript:void(0);' data-c='" + v.c_id + "' data-u='" + v.u_id + "' data-id=" + v.oid + " class='cancel-order'>取消报名</a>&nbsp;";
              }
              if (v.is_check) {
                if (v.check_ok) {
                  atmp += "<a href='javascript:void(0);' data-c='" + v.c_id + "' data-u='" + v.u_id + "' class='refuse-order'>拒绝报名</a>&nbsp;";
                } else {
                  atmp += "<a href='javascript:void(0);' data-c='" + v.c_id + "' data-u='" + v.u_id + "' class='check-order'>允许报名</a>&nbsp;";
                }
              } else {
                atmp += "<a href='javascript:void(0);' data-c='" + v.c_id + "' data-u='" + v.u_id + "' class='check-order'>允许报名</a><br/>";
                atmp += "<a href='javascript:void(0);' data-c='" + v.c_id + "' data-u='" + v.u_id + "' class='refuse-order'>拒绝报名</a>";
              }
            }
          } else {
            if (v.is_cancel) {
              atmp += "<a href='javascript:void(0);'>已取消报名</a>";
            } else {
              if (v.check_ok) {
                atmp += "<a href='javascript:void(0);'>已允许报名</a>";
              } else {
                atmp += "<a href='javascript:void(0);'>已拒绝报名</a>";
              }
            }
          }
          tr_after = "</td></tr>";
          tr = tr_pre + atmp + tr_after;
          return $('.order-list table tbody').append(tr);
        });
      });
    };
    open_order_list = function(course_id, opera) {
      return $.fancybox.open($('.order-list'), {
        padding: 0,
        autoSize: true,
        minWidth: 1000,
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
          $('.order-list .content table tbody').html('');
          return get_order_list(course_id, opera);
        }
      });
    };
    check_order = function(cid, uid, type, obj) {
      return $.get('/manager/orders/check', {
        cid: cid,
        uid: uid,
        type: type
      }, function(ret) {
        if (ret.success) {
          obj.removeAttr('class');
          if (type === 'refuse') {
            return obj.text('已拒绝');
          } else {
            return obj.text('已同意');
          }
        }
      });
    };
    generate_order = function(cu_arr) {
      return $.post('/manager/orders', {
        data: cu_arr
      }, function(ret) {
        if (ret.success) {
          $.fancybox.close();
          $('.employee-box .multiple_start_button').removeClass('info').addClass('success').text('恭喜您,报名成功,请等待系统教务审核！');
          return window.location.href = '/manager/orders?t=w';
        }
      });
    };
    $('body').on('click', '.search_course', function(e) {
      var search_data;
      e.preventDefault();
      search_data = $('form.search-course').serialize();
      return $.get("/manager/orders", search_data, function() {});
    });
    $('body').on('click', '.pagination a', function() {
      var city, code, content, end, g_data, name, page, start;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        name = $(this).data('name');
        code = $(this).data('code');
        content = $(this).data('content');
        city = $(this).data('city');
        start = $(this).data('start');
        end = $(this).data('end');
        g_data = {
          page: page,
          name: name,
          code: code,
          content: content,
          city: city,
          start: start,
          end: end
        };
        if (page) {
          return $.get("/manager/orders", g_data, function() {});
        }
      }
    });
    $('body').on('click', 'table tr th .checklist li', function() {
      if ($(this).attr('aria-checked') === 'true') {
        return $('table tr td li').attr('aria-checked', true);
      } else {
        return $('table tr td li').attr('aria-checked', false);
      }
    });
    $('body').on('click', 'button.start', function() {
      var id_arr;
      if ($('table tr td li[aria-checked="true"]').length > 0) {
        id_arr = [];
        $('table tr td li[aria-checked="true"]').each(function() {
          return id_arr.push($(this).data('id'));
        });
        if (id_arr.length > 0) {
          return open_select_box(id_arr);
        }
      }
    });
    $('body').on('click', '.employee-box li', function(e) {
      if ($(this).data('cancel') === false && $(this).data('enroll') === true) {
        return $(this).attr('aria-checked', true);
      }
    });
    $('body').on('click', '.employee-box .multiple_start_button', function() {
      var cu_arr;
      cu_arr = [];
      $('.employee-box ul li').each(function() {
        var ty;
        ty = $(this).attr('aria-checked') === 'true' ? 'enroll' : 'cancel';
        return cu_arr.push({
          c_id: $(this).data('id'),
          u_id: $(this).data('u'),
          type: ty
        });
      });
      return generate_order(cu_arr);
    });
    $('body').on('click', 'a.show-order', function() {
      var course_id, opera;
      course_id = $(this).data('id');
      opera = $(this).data('opera');
      return open_order_list(course_id, opera);
    });
    $('body').on('click', 'a.refuse-order,a.check-order', function() {
      var cid, type, uid;
      cid = $(this).data('c');
      uid = $(this).data('u');
      if ($(this).hasClass('refuse-order')) {
        type = 'refuse';
      } else {
        type = 'check';
      }
      return check_order(cid, uid, type, $(this));
    });
    $('body').on('click', 'a.cancel-order', function() {
      var $obj, oid;
      $obj = $(this);
      oid = $(this).data('id');
      return $.get('/manager/orders/cancel', {
        id: oid
      }, function(ret) {
        if (ret.success) {
          return $obj.removeAttr('class').text('已取消报名');
        }
      });
    });
    return $('body').on('click', 'button.close-box', function() {
      return $.fancybox.close();
    });
  });

}).call(this);
