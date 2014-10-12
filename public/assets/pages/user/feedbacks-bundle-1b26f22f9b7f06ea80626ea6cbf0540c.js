(function() {
  $(function() {
    $('body').on('click', '.tablist li', function() {
      var href;
      href = $(this).attr('href');
      return $.get("" + href, {}, function() {});
    });
    return $('body').on('click', 'td.no-data button', function() {
      var arr, cid, q1, q2, q3, q4, q5, table;
      table = $(this).parents('table');
      arr = [];
      q1 = table.find('input[name="question_1"]:checked').val();
      if (q1) {
        arr.push(q1);
      }
      q2 = table.find('input[name="question_2"]:checked').val();
      if (q2) {
        arr.push(q2);
      }
      q3 = table.find('input[name="question_3"]:checked').val();
      if (q3) {
        arr.push(q3);
      }
      q4 = table.find('input[name="question_4"]:checked').val();
      if (q4) {
        arr.push(q4);
      }
      q5 = table.find('input[name="question_5"]:checked').val();
      if (q5) {
        arr.push(q5);
      }
      if (arr.length < 5) {
        return false;
      }
      cid = $(this).data('cid');
      if (cid) {
        return $.post('/user/feedbacks', {
          data: arr,
          c_id: cid
        }, function(ret) {
          if (ret.success) {
            return window.location.href = '/user/feedbacks';
          }
        });
      }
    });
  });

}).call(this);
