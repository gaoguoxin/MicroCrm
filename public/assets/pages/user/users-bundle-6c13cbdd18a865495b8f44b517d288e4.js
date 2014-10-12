(function($){

	$.regex = $.regex || {};
	$.extend($.regex, {
		isEmail: function(email) {
			return (/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email));
		},
		isPhone: function(phone) {
			return /^((\d{11})|(\d{3}-\d{8})|(\d{4}-\d{7})|(\d{3}-\d{4}-\d{4}))$/.test(phone);
		},
		isMobile: function(mobile) {
			return (/^(13[0-9]|15[012356789]|18[0-9]|14[57]|170)[0-9]{8}$/.test(mobile));
		},

		isYidongNumber:function(number){
			return (/^1(3[4-9]|4[7]|5[012789]|8[2378])\d{8}$/.test(number));
		},

		isDianxinNumber:function(number){
			return (/^1([35]3|8[09])\d{8}$/.test(number));
		},

		isLianTongNumber:function(number){
			return (/^1(3[0-2]|4[5]|5[56]|8[0156])\d{8}$/.test(number));
		},

		isIDCard:function(idcard){
			return /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}(\d|(x|X))$/.test(idcard);
		},
		isPostcode: function(postcode) {
			return /^\d{6}$/.test(postcode);
		},

		isQq:function(qq){
			return (/^\d{5,}$/.test(qq));
		},


		isUrl: function(url) {
			if(!url) return false;
			var prefix = url.split('?')[0].split('#')[0];
			var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
				+ "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@
				+ "(([0-9]{1,3}\.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184
				+ "|" // 允许IP和DOMAIN（域名）
				+ "([0-9a-z_!~*'()-]+\.)*" // 域名- www.
				+ "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\." // 二级域名
				+ "[a-z]{2,6})" // first level domain- .com or .museum
				+ "(:[0-9]{1,4})?" // 端口- :80
				+ "((/?)|" // a slash isn't required if there is no file name
				+ "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
			var re=new RegExp(strRegex);
			return re.test(prefix);
		}
	});

})(jQuery);
(function() {
  $(function() {
    var add_flag, check_password, check_presense, confirm_ipt, delay, email_ipt, mobile_ipt, name_ipt, password_ipt, remove_flag, send_info_ajax, send_password_ajax;
    name_ipt = $('#name');
    email_ipt = $('#email');
    mobile_ipt = $('#mobile');
    password_ipt = $('#password');
    confirm_ipt = $('#confirm_password');
    delay = function(ms, func) {
      return setTimeout(func, ms);
    };
    check_presense = function() {
      if ($.trim(name_ipt.val()).length === 0) {
        add_flag(name_ipt, '请认真填写您的姓名');
        return;
      }
      if ($.trim(email_ipt.val()).length === 0 || !$.regex.isEmail(email_ipt.val())) {
        add_flag(email_ipt, '您的邮箱格式不正确');
        return;
      }
      if ($.trim(mobile_ipt.val()).length === 0 || !$.regex.isMobile(mobile_ipt.val())) {
        add_flag(mobile_ipt, '您的手机号码格式不正确');
        return;
      }
      return send_info_ajax();
    };
    check_password = function() {
      if (!($.trim(password_ipt.val()).length > 0)) {
        return false;
      }
      if (password_ipt.val() !== confirm_ipt.val()) {
        add_flag(confirm_ipt, '两次密码不匹配');
        return;
      }
      return send_password_ajax();
    };
    send_password_ajax = function() {
      return $.ajax({
        data: {
          password: $.trim(password_ipt.val())
        },
        url: '/user/users/update_pwd',
        method: "POST",
        success: function(ret) {
          $('.pass-submit').removeClass('info').addClass('success').text('修改成功!');
          return delay(2000, function() {
            return window.location.reload();
          });
        }
      });
    };
    send_info_ajax = function() {
      return $.post('/user/users/update_info', $('form.info').serialize(), function(ret) {
        if (ret.success) {
          $('button.info-submit').removeClass('info').addClass('success').text('修改成功!');
          return delay(2000, function() {
            return window.location.reload();
          });
        } else {
          if (ret.value.error_code === 'error_5') {
            return add_flag(email_ipt, '该邮箱已经存在!');
          } else {
            return add_flag(mobile_ipt, '该手机号已经存在!');
          }
        }
      });
    };
    add_flag = function(obj, msg) {
      var append_str;
      if (!(obj.prev('label').find('span').length > 0)) {
        append_str = "<span>" + msg + "</span>";
        obj.prev('label').append(append_str);
        obj.attr('aria-invalid', true);
      }
      return $("html, body").animate({
        scrollTop: 0
      }, 500);
    };
    remove_flag = function(obj) {
      obj.removeAttr('aria-invalid');
      return obj.prev('label').find('span').remove();
    };
    $('input').focus(function() {
      return remove_flag($(this));
    });
    $('button.info-submit').click(function(e) {
      e.preventDefault();
      return check_presense();
    });
    $('form.info input,textarea').keydown(function(e) {
      if (e.witch === 13) {
        return $('button.info-submit').click();
      }
    });
    return $('form.pwd button.pass-submit').click(function(e) {
      e.preventDefault();
      return check_password();
    });
  });

}).call(this);
