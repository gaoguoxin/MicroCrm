(function(){$(function(){var t,a,e,n;return $("#search_start,#search_end").datepicker({dateFormat:"yy-mm-dd",showAnim:"show"}),$("body").on("click",".search-submit",function(t){var a;return t.preventDefault(),a=$("form.search-orders").serialize(),$.get("/admin/orders",a,function(){})}),$("body").on("click",".pagination a",function(){var t,a,e,n,i,r,c,s,o,d,l,u,h;return!$(this).hasClass("disabled")&&(o=$(this).data("page"),e=$(this).data("code"),s=$(this).data("name"),d=$(this).data("start"),r=$(this).data("end"),l=$(this).data("state"),u=$(this).data("status"),t=$(this).data("cancel"),i=$(this).data("content"),a=$(this).data("city"),n=$(this).data("company"),h=$(this).data("t"),c={page:o,code:e,name:s,start:d,end:r,state:l,status:u,cancel:t,content:i,city:a,company:n,t:h},o)?$.get("/admin/orders",c,function(){}):void 0}),$("body").on("click",".check-tool .checklist li",function(){return"true"===$(this).attr("aria-checked")?$("td.opera li").attr("aria-checked",!0):$("td.opera li").attr("aria-checked",!1)}),$("body").on("click",".check-tool button",function(){var t;return!$(this).hasClass("disabled")&&$('td.opera .checklist li[aria-checked="true"]').length>0&&(t=[],$('td.opera .checklist li[aria-checked="true"]').each(function(){return t.push($(this).data("id"))}),t.length>0)?($(this).hasClass("absent")&&n(t,"absent"),$(this).hasClass("attend")&&n(t,"attend"),$(this).hasClass("allow")&&a(t,"allow"),$(this).hasClass("refuse")&&a(t,"refuse"),$(this).hasClass("cancel")&&e(t),$(this).addClass("disabled")):void 0}),$("body").on("click","button.cancel-operation",function(){return $(".checklist li").attr("aria-checked",!1),$.fancybox.close()}),$("body").on("click","button.sure-operation",function(){return t(window.id_arr),$.fancybox.close()}),e=function(t){return $.fancybox.open($(".confirm-box"),{padding:0,autoSize:!0,scrolling:!1,openEffect:"none",closeEffect:"none",helpers:{overlay:{locked:!1,closeClick:!1,css:{background:"rgba(51, 51, 51, 0.2)"}}},beforeShow:function(){return window.id_arr=t},afterClose:function(){return window.id_arr=""}})},n=function(t,a){return $.post("/admin/orders/make_attend",{data:t,type:a},function(e){var n;return e.success?(n="absent"===a?"\u7f3a\u5e2d":"\u51fa\u5e2d",$.each(t,function(t,a){return $("li[data-id='"+a+"']").parents("td").prev("td").text(n)})):void 0})},a=function(t,a){return $.post("/admin/orders/check_order",{data:t,type:a},function(e){var n;return e.success?(n="allow"===a?"\u5ba1\u6838\u901a\u8fc7":"\u5ba1\u6838\u62d2\u7edd",$.each(t,function(t,a){return $("li[data-id='"+a+"']").parents("td").siblings("td.state").text(n)})):void 0})},t=function(t){return $.post("/admin/orders/cancel_order",{data:t},function(a){return a.success?$.each(t,function(t,a){return $("li[data-id='"+a+"']").parents("td").siblings("td.cancel").text("\u53d6\u6d88")}):void 0})}})}).call(this);