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
    var check_format, check_regist, check_required, company_ipt, email_ipt, flag_notice, mobile_ipt, name_ipt, password_ipt, remove_notice, send_ajax;
    name_ipt = $('input[name="name"]');
    email_ipt = $('input[name="email"]');
    mobile_ipt = $('input[name="mobile"]');
    password_ipt = $('input[name="password"]');
    company_ipt = $('select');
    flag_notice = function(obj, msg) {
      if (msg) {
        obj.parents('.ipt-container').addClass("invalid");
        if (obj.siblings('.tooltip').length > 0) {
          return obj.siblings('.tooltip').text('').text(msg).removeClass('animated bounceOutRight').addClass('animated bounceInRight').show();
        } else {
          return obj.parents('.ipt-container').find('.tooltip').text('').text(msg).removeClass('animated bounceOutRight').addClass('animated bounceInRight').show();
        }
      } else {
        return obj.parents('.ipt-container').addClass("valid");
      }
    };
    remove_notice = function(obj) {
      obj.parents('.ipt-container').removeClass("invalid").removeClass('valid');
      if (obj.siblings('.tooltip:visible').length > 0) {
        return obj.siblings('.tooltip').removeClass('animated bounceInRight').addClass('animated bounceOutRight').text('');
      } else {
        if (obj.parents('.ipt-container').find('.tooltip:visible').length > 0) {
          return obj.parents('.ipt-container').find('.tooltip:visible').removeClass('animated bounceInRight').addClass('animated bounceOutRight').text('');
        }
      }
    };
    check_format = function(obj) {
      var name;
      name = obj.attr('name');
      if (name === 'email') {
        if (!$.regex.isEmail($.trim(obj.val()))) {
          flag_notice(obj, '邮箱格式错误');
          return;
        }
      } else {
        if (!$.regex.isMobile($.trim(obj.val()))) {
          flag_notice(obj, '手机号格式错误');
          return;
        }
      }
      return check_regist("" + name, $.trim(obj.val()));
    };
    check_regist = function(col, value) {
      var data;
      if (col === 'email') {
        data = {
          email: value
        };
      }
      if (col === 'mobile') {
        data = {
          mobile: value
        };
      }
      if (value.length > 0) {
        return $.post("/users/check_exist", data, function(ret) {
          if (ret.success) {
            if (ret.value) {
              if (col === 'email') {
                return flag_notice(email_ipt, '该邮箱已被使用');
              } else {
                return flag_notice(mobile_ipt, '该手机已被占用');
              }
            } else {
              if (col === 'email') {
                return flag_notice(email_ipt);
              } else {
                return flag_notice(mobile_ipt);
              }
            }
          }
        });
      }
    };
    check_required = function() {
      var company, email, mobile, name, password;
      name = $.trim(name_ipt.val());
      email = $.trim(email_ipt.val());
      mobile = $.trim(mobile_ipt.val());
      password = $.trim(password_ipt.val());
      company = company_ipt.val();
      if (name.length === 0) {
        flag_notice(name_ipt, '请输入姓名');
        return;
      }
      if (email.length === 0) {
        flag_notice(email_ipt, '请输入邮箱');
        return;
      }
      if (mobile.length === 0) {
        flag_notice(mobile_ipt, '请输入手机号');
        return;
      }
      if (password.length === 0) {
        flag_notice(password_ipt, '请输入密码');
        return;
      }
      if (!company) {
        flag_notice(company_ipt, '请选择所属单位');
        return;
      }
      return send_ajax();
    };
    send_ajax = function() {
      var company_id, name, password, r_email, r_mobile;
      name = name_ipt.val();
      r_email = email_ipt.val();
      r_mobile = mobile_ipt.val();
      password = password_ipt.val();
      company_id = company_ipt.val();
      return $.post("/users", {
        name: name,
        email: r_email,
        mobile: r_mobile,
        password: password,
        company_id: company_id
      }, function(ret) {
        if (ret.success) {
          return window.location.href = "/user/users";
        } else {
          if (ret.value.error_code === "error_5") {
            $('.email.tooltip').show();
          }
          if (ret.value.error_code === "error_6") {
            return $('.mobile.tooltip').show();
          }
        }
      });
    };
    $('.form input,.form select').focus(function() {
      return remove_notice($(this));
    });
    email_ipt.blur(function() {
      return check_format(email_ipt);
    });
    mobile_ipt.blur(function() {
      return check_format(mobile_ipt);
    });
    $('.reg-btn').click(function(e) {
      e.preventDefault();
      return check_required();
    });
    return $('password').keydown(function(e) {
      if (e.which === 13) {
        return $('.form-group button').click;
      }
    });
  });

}).call(this);
