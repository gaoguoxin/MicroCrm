(function() {
  $(function() {
    var change_point, check_feedback, get_feed_info, show_feeback_box;
    $("#search_start,#search_end").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
    });
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
      return $.get('/admin/feedbacks/get_feed_info', {
        cid: cid
      }, function(ret) {
        if (ret.success) {
          return $.each(ret.value, function(k, v) {
            var tr;
            tr = "<tr> <td>" + v.uname + "</td> <td class='point'  data-uid=" + v.uid + " data-cid=" + v.cid + " data-q='question_1' data-id=" + v.f_id + " ><span>" + v.q_1 + "分</span><input type='number' name='point' maxlength=2 value=" + v.q_1 + "></td> <td class='point'  data-uid=" + v.uid + " data-cid=" + v.cid + " data-q='question_2' data-id=" + v.f_id + " ><span>" + v.q_2 + "分</span><input type='number' name='point' maxlength=2 value=" + v.q_2 + "></td> <td class='point'  data-uid=" + v.uid + " data-cid=" + v.cid + " data-q='question_3' data-id=" + v.f_id + " ><span>" + v.q_3 + "分</span><input type='number' name='point' maxlength=2 value=" + v.q_3 + "></td> <td class='point'  data-uid=" + v.uid + " data-cid=" + v.cid + " data-q='question_4' data-id=" + v.f_id + " ><span>" + v.q_4 + "分</span><input type='number' name='point' maxlength=2 value=" + v.q_4 + "></td> <td class='point'  data-uid=" + v.uid + " data-cid=" + v.cid + " data-q='question_5' data-id=" + v.f_id + " ><span>" + v.q_5 + "分</span><input type='number' name='point' maxlength=2 value=" + v.q_5 + "></td> <td class='tot'>" + v.tot + "分</td> <td class='status'>" + v.status + "</td> <td class='check' ><ul class='checklist turquoise large'><li data-uid=" + v.uid + " data-cid=" + v.cid + " data-id=" + v.f_id + " >审核</li></ul></td> </tr>";
            return $('.feedback-box .content table tbody').append(tr);
          });
        }
      });
    };
    change_point = function(obj) {
      var cid, p, q, uid;
      cid = obj.parents('td').data('cid');
      uid = obj.parents('td').data('uid');
      q = obj.parents('td').data('q');
      p = obj.val();
      return $.post('/admin/feedbacks/change_point', {
        cid: cid,
        uid: uid,
        q: q,
        p: p
      }, function(ret) {
        if (ret.success) {
          obj.val(p).hide().siblings('span').text(p + '分').show();
          obj.parents('tr').find('.tot').text(ret.value + '分');
          return obj.parents('tr').find('.status').text('等待审核');
        }
      });
    };
    check_feedback = function(arr, obj) {
      var cid, r, result, text, uid;
      cid = obj.parents('td').data('cid');
      uid = obj.parents('td').data('uid');
      if (obj.hasClass('pass')) {
        result = 'pass';
        text = '审核通过';
        r = 'pass';
      } else {
        result = 'refuse';
        text = '审核拒绝';
        r = 'refuse';
      }
      return $.post('/admin/feedbacks/check_feedback', {
        data: arr,
        r: r
      }, function(ret) {
        if (ret.success) {
          return $.each(arr, function(k, v) {
            var check_result, li, td;
            li = $(".checklist li[data-uid='" + v.uid + "']");
            td = li.parents('td');
            check_result = td.prev('td');
            if (check_result.text() !== '尚未反馈') {
              return check_result.text(text);
            }
          });
        }
      });
    };
    $('body').on('click', 'a.show-feedback', function() {
      var cid;
      cid = $(this).data('id');
      return show_feeback_box(cid);
    });
    $('body').on('click', 'button.close-btn', function() {
      return $.fancybox.close();
    });
    $('body').on('click', '.search-feedbacks', function(e) {
      var search_data;
      e.preventDefault();
      search_data = $('form.search-form').serialize();
      return $.get("/admin/feedbacks", search_data, function() {});
    });
    $('body').on('click', '.pagination a', function() {
      var city, code, content, g_data, name, page, status, t;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        status = $(this).data('status');
        code = $(this).data('code');
        t = $(this).data('t');
        name = $(this).data('name');
        city = $(this).data('city');
        content = $(this).data('content');
        g_data = {
          page: page,
          status: status,
          code: code,
          t: t,
          name: name,
          city: city,
          content: content
        };
        if (page) {
          return $.get("/admin/feedbacks", g_data, function() {});
        }
      }
    });
    $('body').on('click', 'td.point', function() {
      return $(this).find('span').hide().siblings('input').show();
    });
    $('body').on('keydown', 'td.point input', function(e) {
      if (e.which === 13) {
        return change_point($(this));
      }
    });
    $('body').on('blur', 'td.point input', function(e) {
      return change_point($(this));
    });
    $('body').on('click', '.check-tool .checklist li', function() {
      if ($(this).attr('aria-checked') === 'true') {
        return $('td.check li').attr('aria-checked', true);
      } else {
        return $('td.check li').attr('aria-checked', false);
      }
    });
    return $('body').on('click', 'button.pass,button.refuse', function() {
      var id_arr;
      if ($('td.check li[aria-checked="true"]').length > 0) {
        id_arr = [];
        $('td.check li[aria-checked="true"]').each(function() {
          return id_arr.push({
            cid: $(this).data('cid'),
            uid: $(this).data('uid')
          });
        });
        if (id_arr.length > 0) {
          return check_feedback(id_arr, $(this));
        }
      }
    });
  });

}).call(this);
