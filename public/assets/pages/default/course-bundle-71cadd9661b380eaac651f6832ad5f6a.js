(function(){$(function(){var t,n,e;return t=$(".bottom-left").height(),n=$(".bottom-right .right-cont").height(),t>n&&$(".bottom-right .right-cont").height(t),$("body").on("click","button.feed-btn",function(){var t,n,e,o,i,c;return t=[],n=$('input[name="question_1"]:checked').val(),n&&t.push(n),e=$('input[name="question_2"]:checked').val(),e&&t.push(e),o=$('input[name="question_3"]:checked').val(),o&&t.push(o),i=$('input[name="question_4"]:checked').val(),i&&t.push(i),c=$('input[name="question_5"]:checked').val(),c&&t.push(c),t.length<5?!1:window.u_id.length>0?$.post("/feedbacks",{data:t,c_id:window.c_id},function(t){return t.success?window.location.href="/feedbacks?t=p":$("button.feed-btn").text("\u65e0\u6743\u53cd\u9988!").css({background:"#e74c3c"})}):(window.location.href="/login?ref=/courses/"+window.c_id,!1)}),$("body").on("click","button.large.start",function(){return e([window.c_id])}),e=function(t){return $.post("/orders",{data:t},function(t){return t.success?window.location.href=t.value===!1?"/login":"/orders?w=true":void 0})}})}).call(this);