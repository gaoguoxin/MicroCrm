(function(){$(function(){return $("body").on("click","button.success.start",function(){return $.post("/orders",{data:[window.c_id]},function(n){return n.success?window.location.href=n.value===!1?"/login":"/orders?w=true":void 0})}),$("body").on("click","button.feed-btn",function(){var n,e,t,o,c,i;return n=[],e=$('input[name="question_1"]:checked').val(),e&&n.push(e),t=$('input[name="question_2"]:checked').val(),t&&n.push(t),o=$('input[name="question_3"]:checked').val(),o&&n.push(o),c=$('input[name="question_4"]:checked').val(),c&&n.push(c),i=$('input[name="question_5"]:checked').val(),i&&n.push(i),n.length<5?!1:window.u_id.length>0?$.post("/feedbacks",{data:n,c_id:window.c_id},function(n){return n.success?window.location.href="/feedbacks?t=p":$("button.feed-btn").text("\u65e0\u6743\u53cd\u9988")}):(window.location.href="/login?ref=/courses/"+window.c_id,!1)})})}).call(this);