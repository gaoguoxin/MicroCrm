(function() {
  $(function() {
    var account_ipt, password_ipt, send_ajax;
    account_ipt = $('input[name="email_mobile"]');
    password_ipt = $('input[name="password"]');
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
          return $('.align-center').text('用户名或密码错误');
        }
      });
    };
    $('.form input').focus(function() {
      return $('.align-center').htmp('&nbsp;');
    });
    return $('.login-btn').click(function(e) {
      e.preventDefault();
      return send_ajax();
    });
  });

}).call(this);
