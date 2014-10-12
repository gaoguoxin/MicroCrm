(function() {
  $(function() {
    var get_feed_info, show_feeback_box;
    show_feeback_box = function(cid) {
      return $.fancybox.open($('.feedback-box'), {
        padding: 0,
        autoSize: true,
        minWidth: 1000,
        minHeight: 600,
        openEffect: 'none',
        closeEffect: 'none',
        helpers: {
          overlay: {
            locked: false,
            closeClick: false,
            css: {
              'background': 'rgba(51, 51, 51, 0.2)'
            }
          }
        },
        beforeShow: function() {
          $('.feedback-box .content table tbody').html('');
          return get_feed_info(cid);
        }
      });
    };
    get_feed_info = function(cid) {
      return $.get('/manager/feedbacks/get_feed_info', {
        cid: cid
      }, function(ret) {
        if (ret.success) {
          return $.each(ret.value, function(k, v) {
            var tr;
            tr = "<tr><td>" + v.uname + "</td><td>" + v.q_1 + "分</td><td>" + v.q_2 + "分</td><td>" + v.q_3 + "分</td><td>" + v.q_4 + "分</td><td>" + v.q_5 + "分</td><td>" + v.tot + "分</td></tr>";
            return $('.feedback-box .content table tbody').append(tr);
          });
        }
      });
    };
    $('body').on('click', 'a.show_feedback', function() {
      var cid;
      cid = $(this).data('id');
      return show_feeback_box(cid);
    });
    return $('body').on('click', 'button.close-btn', function() {
      return $.fancybox.close();
    });
  });

}).call(this);
