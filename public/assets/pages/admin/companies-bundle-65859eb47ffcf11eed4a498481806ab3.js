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
    var check_presense, delay, flash_notice, remove_notice, submit_company_info;
    $("#search_start,#search_end").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
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
    check_presense = function(obj) {
      var manager, name;
      name = $.trim($('#name').val());
      manager = $.trim($('#manager').val());
      if (name.length <= 0) {
        $('#name').parents('.padded').addClass('invalid').removeClass('valid');
        $("html, body").animate({
          scrollTop: 0
        }, 500);
        return;
      }
      if (name.indexOf('其他') < 0) {
        if (manager.length <= 0) {
          $('#manager').parents('.padded').addClass('invalid').removeClass('valid');
          $("html, body").animate({
            scrollTop: 0
          }, 500);
          return;
        } else {
          $('.invalid').removeClass('invalid');
        }
      }
      return submit_company_info(obj);
    };
    remove_notice = function() {
      return $('.flash-notice').removeClass('animated bounceInRight').addClass('animated bounceOutRight');
    };
    submit_company_info = function(obj) {
      var ajax_url, data, msg;
      data = $('form.new-company').serialize();
      if (obj.hasClass('upd')) {
        ajax_url = "/admin/companies/update_info";
        msg = '单位信息修改成功！';
      } else {
        ajax_url = "/admin/companies";
        msg = '新单位创建成功,点击列表进行查看!';
      }
      return $.post(ajax_url, data, function(ret) {
        if (ret.success) {
          return flash_notice(msg);
        }
      });
    };
    $('body').on('click', '.tab-nav:last', function(e) {
      return $.get("/admin/companies/new", {}, function() {});
    });
    $('body').on('click', '.search-submit', function(e) {
      var search_data;
      e.preventDefault();
      search_data = $('form.search-form').serialize();
      return $.get("/admin/companies", search_data, function() {});
    });
    $('body').on('click', 'td a.delete-company', function(e) {
      var cid, curr_tr;
      curr_tr = $(this).parents('tr');
      cid = $(this).data('cid');
      return $.get("/admin/companies/delete", {
        id: cid
      }, function(ret) {
        if (ret.success) {
          return curr_tr.remove();
        }
      });
    });
    $('body').on('click', '.pagination a', function() {
      var g_data, level, page, search_account, search_name, status, type;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        status = $(this).data('status');
        level = $(this).data('level');
        type = $(this).data('type');
        search_name = $(this).data('name');
        search_account = $(this).data('account');
        g_data = {
          page: page,
          search_status: status,
          search_level: level,
          search_type: type,
          search_name: search_name,
          search_account: search_account
        };
        if (page) {
          return $.get("/admin/companies", g_data, function() {});
        }
      }
    });
    $('body').on('focus', 'form.new-company input', function(e) {
      return $(this).parents('.padded').removeClass('invalid').removeClass('valid');
    });
    $('body').on('click', '.search-manager', function(e) {
      var $this, data, manager, _base;
      $this = $(this);
      manager = $.trim($('#manager').val());
      if ($.regex.isMobile(manager) || $.regex.isEmail(manager)) {
        data = {
          account: manager
        };
        return $.get("/admin/companies/search_manager", data, function(ret) {
          if (ret.success) {
            if (ret.value) {
              $this.parents('.padded').addClass('valid');
              return $this.text('匹配成功!');
            } else {
              $this.parents('.padded').addClass('invalid');
              return $this.text('不存在，创建?');
            }
          }
        });
      } else {
        if (!((typeof (_base = $('form.new-company #name').val()).indexOf === "function" ? _base.indexOf('其他') : void 0) >= 0)) {
          return $(this).parents('.padded').addClass('invalid');
        }
      }
    });
    $('body').on('keydown', 'form.new-company #manager', function(e) {
      if (e.which === 9) {
        return $('.search-manager').click();
      }
    });
    $('body').on('focusout', 'form.new-company #manager', function(e) {
      return $('.search-manager').click();
    });
    $('body').on('click', 'form.new-company .info-submit', function(e) {
      var $obj;
      $obj = $(this);
      e.preventDefault();
      return check_presense($obj);
    });
    $('body').on('keydown', 'form.new-company #description', function(e) {
      if (e.which === 13) {
        return $('form.new-company .info-submit').click();
      }
    });
    return $('body').on('click', 'a.edit-company', function(e) {
      var cid;
      cid = $(this).attr('id');
      return $.get("/admin/companies/" + cid + "/edit", {}, function(ret) {});
    });
  });

}).call(this);
