(function() {
  $(function() {
    var account_ipt, check_required, flag_notice, open_forget_box, password_ipt, remove_notice, send_ajax;
    account_ipt = $('input[name="email_mobile"]');
    password_ipt = $('input[name="password"]');
    flag_notice = function(obj, msg) {
      obj.parents('.ipt-container').addClass("invalid");
      return obj.siblings('.tooltip').text('').text(msg).removeClass('animated bounceOutRight').addClass('animated bounceInRight').show();
    };
    remove_notice = function(obj) {
      obj.parents('.ipt-container').removeClass("invalid");
      if (obj.siblings('.tooltip:visible').length > 0) {
        return obj.siblings('.tooltip').removeClass('animated bounceInRight').addClass('animated bounceOutRight').text('');
      }
    };
    check_required = function() {
      var email_mobile, password;
      email_mobile = $.trim(account_ipt.val());
      password = $.trim(password_ipt.val());
      if (email_mobile.length === 0) {
        flag_notice(account_ipt, '请输入帐号');
        return false;
      }
      if (password.length === 0) {
        flag_notice(password_ipt, '请输入密码');
        return false;
      }
      return send_ajax();
    };
    send_ajax = function() {
      var account, password, ref, rem;
      account = account_ipt.val();
      password = password_ipt.val();
      rem = $('.remember-me').attr('aria-checked');
      ref = window.location.href.split('ref=')[1];
      return $.post("/sessions", {
        email_mobile: account,
        password: password,
        remember: rem,
        ref: ref
      }, function(ret) {
        if (ret.success) {
          return window.location.href = '/after_sign_in?ref=' + decodeURIComponent(ret.value.ref);
        } else {
          if (ret.value.error_code === "error_3") {
            return flag_notice(account_ipt, '该用户不存在');
          } else {
            return flag_notice(password_ipt, '您输入的密码有误');
          }
        }
      });
    };
    open_forget_box = function() {
      return $.fancybox.open($('.forget-box'), {
        padding: 0,
        autoSize: true,
        scrolling: false,
        minWidth: 500,
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
        beforeShow: function() {},
        afterClose: function() {}
      });
    };
    $('body').on('focus', '.form input', function() {
      return remove_notice($(this));
    });
    $('body').on('click', '.login-btn', function(e) {
      e.preventDefault();
      return check_required();
    });
    $('body').on('keydown', 'password', function(e) {
      if (e.which === 13) {
        return $('.login-btn').click();
      }
    });
    $('body').on('click', 'a.forget-password', function(e) {
      return open_forget_box();
    });
    $('body').on('click', 'span.f-btn', function() {
      var account;
      account = $('.f-mobile').val();
      if (account.length > 0) {
        return $.post("/sessions/fpwd", {
          mobile: account
        }, function(ret) {
          if (ret.success) {
            return $('.forget-box .box').text('新密码已发送到您的手机!');
          } else {
            return $('.forget-box .box').text('该手机号不存在');
          }
        });
      }
    });
    return $('body').on('keydown', '.f-mobile', function(e) {
      if (e.which === 13) {
        return $('span.f-btn').click();
      }
    });
  });

}).call(this);
