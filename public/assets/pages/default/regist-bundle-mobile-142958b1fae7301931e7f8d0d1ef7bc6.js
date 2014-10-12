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
    var check_format, check_required, company_ipt, email_ipt, flag_notice, mobile_ipt, name_ipt, password_ipt, remove_notice, send_ajax;
    name_ipt = $('input[name="name"]');
    email_ipt = $('input[name="email"]');
    mobile_ipt = $('input[name="mobile"]');
    password_ipt = $('input[name="password"]');
    company_ipt = $('select');
    flag_notice = function(msg) {
      return $('.align-center').text(msg);
    };
    remove_notice = function() {
      return $('.align-center').html('&nbsp;');
    };
    check_format = function(ema, mob) {
      if (!$.regex.isEmail($.trim(ema.val()))) {
        flag_notice('邮箱格式错误');
        return;
      }
      if (!$.regex.isMobile($.trim(mob.val()))) {
        flag_notice('手机号格式错误');
        return;
      }
      return send_ajax();
    };
    check_required = function() {
      var company, email, mobile, name, password;
      name = $.trim(name_ipt.val());
      email = $.trim(email_ipt.val());
      mobile = $.trim(mobile_ipt.val());
      password = $.trim(password_ipt.val());
      company = company_ipt.val();
      console.log(name);
      if (name.length === 0) {
        flag_notice('请输入姓名');
        return;
      }
      if (email.length === 0) {
        flag_notice('请输入邮箱');
        return;
      }
      if (mobile.length === 0) {
        flag_notice('请输入手机号');
        return;
      }
      if (password.length === 0) {
        flag_notice('请输入密码');
        return;
      }
      if (!company) {
        flag_notice('请选择所属单位');
        return;
      }
      return check_format(email_ipt, mobile_ipt);
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
          return window.location.href = "/";
        } else {
          if (ret.value.error_code === "error_5") {
            flag_notice('该邮箱已存在');
          }
          if (ret.value.error_code === "error_6") {
            return flag_notice('该手机号码已存在');
          }
        }
      });
    };
    $('input,select').focus(function() {
      return remove_notice();
    });
    return $('.reg-btn').click(function(e) {
      e.preventDefault();
      return check_required();
    });
  });

}).call(this);
