!function(t){t.regex=t.regex||{},t.extend(t.regex,{isEmail:function(t){return/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(t)},isPhone:function(t){return/^((\d{11})|(\d{3}-\d{8})|(\d{4}-\d{7})|(\d{3}-\d{4}-\d{4}))$/.test(t)},isMobile:function(t){return/^(13[0-9]|15[012356789]|18[0-9]|14[57]|170)[0-9]{8}$/.test(t)},isYidongNumber:function(t){return/^1(3[4-9]|4[7]|5[012789]|8[2378])\d{8}$/.test(t)},isDianxinNumber:function(t){return/^1([35]3|8[09])\d{8}$/.test(t)},isLianTongNumber:function(t){return/^1(3[0-2]|4[5]|5[56]|8[0156])\d{8}$/.test(t)},isIDCard:function(t){return/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}(\d|(x|X))$/.test(t)},isPostcode:function(t){return/^\d{6}$/.test(t)},isQq:function(t){return/^\d{5,}$/.test(t)},isUrl:function(t){if(!t)return!1;var n=t.split("?")[0].split("#")[0],e="^((https|http|ftp|rtsp|mms)?://)?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z].[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$",r=new RegExp(e);return r.test(n)}})}(jQuery),function(){$(function(){var t,n,e,r,i,u,o,a,s,l;return o=$('input[name="name"]'),r=$('input[name="email"]'),u=$('input[name="mobile"]'),a=$('input[name="password"]'),e=$("select"),i=function(t){return $(".align-center").text(t)},s=function(){return $(".align-center").html("&nbsp;")},t=function(t,n){return $.regex.isEmail($.trim(t.val()))?$.regex.isMobile($.trim(n.val()))?l():void i("\u624b\u673a\u53f7\u683c\u5f0f\u9519\u8bef"):void i("\u90ae\u7bb1\u683c\u5f0f\u9519\u8bef")},n=function(){var n,s,l,c,d;return c=$.trim(o.val()),s=$.trim(r.val()),l=$.trim(u.val()),d=$.trim(a.val()),n=e.val(),console.log(c),0===c.length?void i("\u8bf7\u8f93\u5165\u59d3\u540d"):0===s.length?void i("\u8bf7\u8f93\u5165\u90ae\u7bb1"):0===l.length?void i("\u8bf7\u8f93\u5165\u624b\u673a\u53f7"):0===d.length?void i("\u8bf7\u8f93\u5165\u5bc6\u7801"):n?t(r,u):void i("\u8bf7\u9009\u62e9\u6240\u5c5e\u5355\u4f4d")},l=function(){var t,n,s,l,c;return n=o.val(),l=r.val(),c=u.val(),s=a.val(),t=e.val(),$.post("/users",{name:n,email:l,mobile:c,password:s,company_id:t},function(t){return t.success?window.location.href="/":("error_5"===t.value.error_code&&i("\u8be5\u90ae\u7bb1\u5df2\u5b58\u5728"),"error_6"===t.value.error_code?i("\u8be5\u624b\u673a\u53f7\u7801\u5df2\u5b58\u5728"):void 0)})},$("input,select").focus(function(){return s()}),$(".reg-btn").click(function(t){return t.preventDefault(),n()})})}.call(this);