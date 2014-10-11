!function(t){t.regex=t.regex||{},t.extend(t.regex,{isEmail:function(t){return/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(t)},isPhone:function(t){return/^((\d{11})|(\d{3}-\d{8})|(\d{4}-\d{7})|(\d{3}-\d{4}-\d{4}))$/.test(t)},isMobile:function(t){return/^(13[0-9]|15[012356789]|18[0-9]|14[57]|170)[0-9]{8}$/.test(t)},isYidongNumber:function(t){return/^1(3[4-9]|4[7]|5[012789]|8[2378])\d{8}$/.test(t)},isDianxinNumber:function(t){return/^1([35]3|8[09])\d{8}$/.test(t)},isLianTongNumber:function(t){return/^1(3[0-2]|4[5]|5[56]|8[0156])\d{8}$/.test(t)},isIDCard:function(t){return/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}(\d|(x|X))$/.test(t)},isPostcode:function(t){return/^\d{6}$/.test(t)},isQq:function(t){return/^\d{5,}$/.test(t)},isUrl:function(t){if(!t)return!1;var e=t.split("?")[0].split("#")[0],n="^((https|http|ftp|rtsp|mms)?://)?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z].[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$",i=new RegExp(n);return i.test(e)}})}(jQuery),function(){$(function(){var t,e,n,i,r,o,a,s,u,l,d;return s=$('input[name="name"]'),r=$('input[name="email"]'),a=$('input[name="mobile"]'),u=$('input[name="password"]'),i=$("select"),o=function(t,e){return e?(t.parents(".ipt-container").addClass("invalid"),t.siblings(".tooltip").length>0?t.siblings(".tooltip").text("").text(e).removeClass("animated bounceOutRight").addClass("animated bounceInRight").show():t.parents(".ipt-container").find(".tooltip").text("").text(e).removeClass("animated bounceOutRight").addClass("animated bounceInRight").show()):t.parents(".ipt-container").addClass("valid")},l=function(t){return t.parents(".ipt-container").removeClass("invalid").removeClass("valid"),t.siblings(".tooltip:visible").length>0?t.siblings(".tooltip").removeClass("animated bounceInRight").addClass("animated bounceOutRight").text(""):t.parents(".ipt-container").find(".tooltip:visible").length>0?t.parents(".ipt-container").find(".tooltip:visible").removeClass("animated bounceInRight").addClass("animated bounceOutRight").text(""):void 0},t=function(t){var n;if(n=t.attr("name"),"email"===n){if(!$.regex.isEmail($.trim(t.val())))return void o(t,"\u90ae\u7bb1\u683c\u5f0f\u9519\u8bef")}else if(!$.regex.isMobile($.trim(t.val())))return void o(t,"\u624b\u673a\u53f7\u683c\u5f0f\u9519\u8bef");return e(""+n,$.trim(t.val()))},e=function(t,e){var n;return"email"===t&&(n={email:e}),"mobile"===t&&(n={mobile:e}),e.length>0?$.post("/users/check_exist",n,function(e){return e.success?e.value?"email"===t?o(r,"\u8be5\u90ae\u7bb1\u5df2\u88ab\u4f7f\u7528"):o(a,"\u8be5\u624b\u673a\u5df2\u88ab\u5360\u7528"):o("email"===t?r:a):void 0}):void 0},n=function(){var t,e,n,l,c;return l=$.trim(s.val()),e=$.trim(r.val()),n=$.trim(a.val()),c=$.trim(u.val()),t=i.val(),0===l.length?void o(s,"\u8bf7\u8f93\u5165\u59d3\u540d"):0===e.length?void o(r,"\u8bf7\u8f93\u5165\u90ae\u7bb1"):0===n.length?void o(a,"\u8bf7\u8f93\u5165\u624b\u673a\u53f7"):0===c.length?void o(u,"\u8bf7\u8f93\u5165\u5bc6\u7801"):t?d():void o(i,"\u8bf7\u9009\u62e9\u6240\u5c5e\u5355\u4f4d")},d=function(){var t,e,n,o,l;return e=s.val(),o=r.val(),l=a.val(),n=u.val(),t=i.val(),$.post("/users",{name:e,email:o,mobile:l,password:n,company_id:t},function(t){return t.success?window.location.href="/user/users":("error_5"===t.value.error_code&&$(".email.tooltip").show(),"error_6"===t.value.error_code?$(".mobile.tooltip").show():void 0)})},$(".form input,.form select").focus(function(){return l($(this))}),r.blur(function(){return t(r)}),a.blur(function(){return t(a)}),$(".reg-btn").click(function(t){return t.preventDefault(),n()}),$("password").keydown(function(t){return 13===t.which?$(".form-group button").click:void 0})})}.call(this);