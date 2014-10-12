(function() {
  $(function() {
    var account_ipt, send_ajax;
    account_ipt = $('input[name="mobile"]');
    send_ajax = function() {
      var account;
      account = account_ipt.val();
      return $.post("/sessions/fpwd", {
        mobile: account
      }, function(ret) {
        if (ret.success) {
          $('.align-center').text('新密码已发送到您的手机');
          return setTimeout(window.location.href = '/', 2000);
        } else {
          return $('.align-center').text('该手机号不存在');
        }
      });
    };
    $('.form input').focus(function() {
      return $('.align-center').htmp('&nbsp;');
    });
    return $('.find-btn').click(function(e) {
      e.preventDefault();
      return send_ajax();
    });
  });

}).call(this);
