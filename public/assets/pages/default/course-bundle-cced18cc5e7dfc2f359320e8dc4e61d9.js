(function() {
  $(function() {
    var bottom_left_height, bottom_right_height, generate_order;
    bottom_left_height = $('.bottom-left').height();
    bottom_right_height = $('.bottom-right .right-cont').height();
    if (bottom_left_height > bottom_right_height) {
      $('.bottom-right .right-cont').height(bottom_left_height);
    }
    $('body').on('click', 'button.feed-btn', function() {
      var arr, q1, q2, q3, q4, q5;
      arr = [];
      q1 = $('input[name="question_1"]:checked').val();
      if (q1) {
        arr.push(q1);
      }
      q2 = $('input[name="question_2"]:checked').val();
      if (q2) {
        arr.push(q2);
      }
      q3 = $('input[name="question_3"]:checked').val();
      if (q3) {
        arr.push(q3);
      }
      q4 = $('input[name="question_4"]:checked').val();
      if (q4) {
        arr.push(q4);
      }
      q5 = $('input[name="question_5"]:checked').val();
      if (q5) {
        arr.push(q5);
      }
      if (arr.length < 5) {
        return false;
      }
      if (!(window.u_id.length > 0)) {
        window.location.href = "/login?ref=/courses/" + window.c_id;
        return false;
      }
      return $.post('/feedbacks', {
        data: arr,
        c_id: window.c_id
      }, function(ret) {
        if (ret.success) {
          return window.location.href = '/feedbacks?t=p';
        } else {
          return $('button.feed-btn').text('无权反馈!').css({
            background: '#e74c3c'
          });
        }
      });
    });
    $('body').on('click', 'button.large.start', function() {
      return generate_order([window.c_id]);
    });
    return generate_order = function(data) {
      return $.post('/orders', {
        data: data
      }, function(ret) {
        if (ret.success) {
          if (ret.value === false) {
            return window.location.href = '/login';
          } else {
            return window.location.href = '/orders?w=true';
          }
        }
      });
    };
  });

}).call(this);
