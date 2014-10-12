(function() {
  $(function() {
    var check_presense, check_serial, delay, flash_notice, remove_notice, submit_card_info;
    $('body').on('focus', "#date_paid,#finished_at", function() {
      return $(this).datepicker({
        dateFormat: "yy-mm-dd",
        showAnim: 'show'
      });
    });
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
    check_serial = function(obj) {
      var serial_number;
      serial_number = $.trim($('#serial_number').val());
      return $.get("/admin/cards/check_serial", {
        num: serial_number
      }, function(ret) {
        if (ret.success && ret.value) {
          $('#serial_number').parent('.padded').addClass('invalid').removeClass('valid');
          return $("html, body").animate({
            scrollTop: 300
          }, 500);
        } else {
          return submit_card_info(obj);
        }
      });
    };
    check_presense = function(obj) {
      var amount_payable, quantity_purchased, serial_number, submit;
      serial_number = $.trim($('#serial_number').val());
      quantity_purchased = $.trim($('#quantity_purchased').val());
      amount_payable = $.trim($('#amount_payable').val());
      submit = true;
      $('#serial_number,#quantity_purchased,#amount_payable').each(function() {
        var v;
        v = $.trim($(this).val());
        if (v.length <= 0) {
          $(this).parents('.padded').addClass('invalid').removeClass('valid');
          $("html, body").animate({
            scrollTop: 300
          }, 500);
          submit = false;
        }
      });
      if (submit) {
        return check_serial(obj);
      }
    };
    remove_notice = function() {
      return $('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight');
    };
    submit_card_info = function(obj) {
      var ajax_url, data, msg;
      data = $('form.new-card').serialize();
      if (obj.hasClass('upd')) {
        ajax_url = "/admin/cards/update_info";
        msg = '学习卡单位信息修改成功！';
      } else {
        ajax_url = "/admin/cards";
        msg = '新学习卡创建成功,点击列表进行查看!';
      }
      return $.post(ajax_url, data, function(ret) {
        if (ret.success) {
          return flash_notice(msg);
        }
      });
    };
    $('body').on('click', '.tab-nav:last', function(e) {
      return $.get("/admin/cards/new", {}, function() {});
    });
    $('body').on('click', '.search_card ', function(e) {
      var search_data;
      e.preventDefault();
      search_data = $('form.search-card').serialize();
      return $.get("/admin/cards", search_data, function() {});
    });
    $('body').on('click', 'td a.delete-card', function(e) {
      var cid, curr_tr;
      curr_tr = $(this).parents('tr');
      cid = $(this).data('cid');
      return $.get("/admin/cards/delete", {
        id: cid
      }, function(ret) {
        if (ret.success) {
          return curr_tr.remove();
        }
      });
    });
    $('body').on('click', '.pagination a', function() {
      var buyer, company, exec, g_data, mobile, page, receipt, serial, status, type;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        serial = $(this).data('serial');
        company = $(this).data('company');
        receipt = $(this).data('receipt');
        buyer = $(this).data('buyer');
        mobile = $(this).data('mobile');
        status = $(this).data('status');
        type = $(this).data('type');
        exec = $(this).data('exec');
        g_data = {
          page: page,
          serial: serial,
          company: company,
          receipt: receipt,
          buyer: buyer,
          mobile: mobile,
          status: status,
          type: type,
          exec: exec
        };
        if (page) {
          return $.get("/admin/cards", g_data, function() {});
        }
      }
    });
    $('body').on('focus', 'form.new-card input', function(e) {
      return $(this).parents('.padded').removeClass('invalid').removeClass('valid');
    });
    $('body').on('click', 'form.new-card .info-submit', function(e) {
      var $obj;
      $obj = $(this);
      e.preventDefault();
      return check_presense($obj);
    });
    $('body').on('keydown', 'form.new-card #post_address', function(e) {
      if (e.which === 13) {
        return $('form.new-card .info-submit').click();
      }
    });
    return $('body').on('click', 'a.edit-card', function(e) {
      var cid;
      cid = $(this).attr('id');
      return $.get("/admin/cards/" + cid + "/edit", {}, function(ret) {});
    });
  });

}).call(this);
