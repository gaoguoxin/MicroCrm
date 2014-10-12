(function() {
  $(function() {
    var check_exist, check_presense, delay, email_ipt, flash_notice, go_top, mobile_ipt, password, remove_notice, submit_user_info;
    $("#search_start,#search_end").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
    });
    email_ipt = $('#email');
    mobile_ipt = $('#mobile');
    password = $.trim($('#password').val());
    delay = function(ms, func) {
      return setTimeout(func, ms);
    };
    go_top = function() {
      return $("html, body").animate({
        scrollTop: 0
      }, 500);
    };
    flash_notice = function(msg) {
      $('.flash-notice').text(msg).addClass('animated bounceInRight').show();
      go_top();
      return delay(2000, function() {
        return window.location.reload();
      });
    };
    remove_notice = function() {
      return $('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight');
    };
    check_exist = function(obj) {
      var data;
      if (obj.attr('id') === 'email') {
        data = {
          email: obj.val()
        };
      }
      if (obj.attr('id') === 'mobile') {
        data = {
          mobile: obj.val()
        };
      }
      data.id = $('input[name="id"]').val();
      return $.post("/admin/users/check_exist", data, function(ret) {
        if (ret.success) {
          if (ret.value) {
            return obj.parents('.padded').addClass('invalid').removeClass('valid');
          } else {
            return obj.parents('.padded').addClass('valid').removeClass('invalid');
          }
        }
      });
    };
    check_presense = function(obj) {
      var check_obj, submit;
      submit = true;
      if (obj.hasClass('upd')) {
        check_obj = $('#name,#email,#mobile');
      } else {
        check_obj = $('#name,#email,#mobile,#password');
      }
      check_obj.each(function() {
        var v;
        v = $.trim($(this).val());
        if (v.length <= 0) {
          $(this).parents('.padded').addClass('invalid').removeClass('valid');
          go_top();
          submit = false;
        }
      });
      if (submit) {
        return submit_user_info(obj);
      }
    };
    submit_user_info = function(obj) {
      var ajax_url, data, msg;
      data = $('form.new-user').serialize();
      if (obj.hasClass('upd')) {
        ajax_url = "/manager/users/update_info";
        msg = '用户信息修改成功！';
      } else {
        ajax_url = "/manager/users";
        msg = '用户信息创建成功,点击列表进行查看!';
      }
      return $.post(ajax_url, data, function(ret) {
        if (ret.success) {
          return flash_notice(msg);
        } else {
          if (ret.value.error_code === "error_5") {
            $('#email').parents('.padded').addClass('invalid').removeClass('valid');
            go_top();
          }
          if (ret.value.error_code === "error_6") {
            $('#mobile').parents('.padded').addClass('invalid').removeClass('valid');
            return go_top();
          }
        }
      });
    };
    $('body').on('click', '.tab-nav:last', function(e) {
      return $.get("/manager/users/new", {}, function() {});
    });
    $('body').on('click', '.search_user', function(e) {
      var search_data;
      e.preventDefault();
      search_data = $('form.search-user').serialize();
      return $.get("/manager/users", search_data, function() {});
    });
    $('body').on('click', 'td a.delete-user', function(e) {
      var cid, curr_tr;
      curr_tr = $(this).parents('tr');
      cid = $(this).data('cid');
      return $.get("/manager/users/delete", {
        id: cid
      }, function(ret) {
        if (ret.success) {
          return curr_tr.remove();
        }
      });
    });
    $('body').on('click', '.pagination a', function() {
      var city, email, end, g_data, interest, name, page, position, start;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        name = $(this).data('name');
        email = $(this).data('email');
        position = $(this).data('position');
        city = $(this).data('city');
        interest = $(this).data('interest');
        start = $(this).data('start');
        end = $(this).data('end');
        g_data = {
          page: page,
          name: name,
          email: email,
          position: position,
          city: city,
          interest: interest,
          start: start,
          end: end
        };
        if (page) {
          return $.get("/manager/users", g_data, function() {});
        }
      }
    });
    $('body').on('focusout', 'form.new-user #email,#mobile', function(e) {
      return check_exist($(this));
    });
    $('body').on('focus', 'form.new-user input', function(e) {
      return $(this).parents('.padded').removeClass('invalid').removeClass('valid');
    });
    $('body').on('click', 'form.new-user .info-submit', function(e) {
      var $obj;
      $obj = $(this);
      e.preventDefault();
      return check_presense($obj);
    });
    return $('body').on('click', 'a.edit-user', function(e) {
      var cid;
      cid = $(this).attr('id');
      return $.get("/manager/users/" + cid + "/edit", {}, function(ret) {});
    });
  });

}).call(this);
