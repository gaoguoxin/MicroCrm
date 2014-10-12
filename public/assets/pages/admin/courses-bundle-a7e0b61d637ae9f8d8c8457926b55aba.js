/*!
 * jquery-timepicker v1.4.12 - A jQuery timepicker plugin inspired by Google Calendar. It supports both mouse and keyboard navigation.
 * Copyright (c) 2014 Jon Thornton - http://jonthornton.github.com/jquery-timepicker/
 * License: 
 */


!function(a){"object"==typeof exports&&exports&&"object"==typeof module&&module&&module.exports===exports?a(require("jquery")):"function"==typeof define&&define.amd?define(["jquery"],a):a(jQuery)}(function(a){function b(a){var b=a[0];return b.offsetWidth>0&&b.offsetHeight>0}function c(b){if(b.minTime&&(b.minTime=u(b.minTime)),b.maxTime&&(b.maxTime=u(b.maxTime)),b.durationTime&&"function"!=typeof b.durationTime&&(b.durationTime=u(b.durationTime)),"now"==b.scrollDefault?b.scrollDefault=u(new Date):b.scrollDefault?b.scrollDefault=u(b.scrollDefault):b.minTime&&(b.scrollDefault=b.minTime),b.scrollDefault&&(b.scrollDefault=f(b.scrollDefault,b)),"string"===a.type(b.timeFormat)&&b.timeFormat.match(/[gh]/)&&(b._twelveHourTime=!0),b.disableTimeRanges.length>0){for(var c in b.disableTimeRanges)b.disableTimeRanges[c]=[u(b.disableTimeRanges[c][0]),u(b.disableTimeRanges[c][1])];b.disableTimeRanges=b.disableTimeRanges.sort(function(a,b){return a[0]-b[0]});for(var c=b.disableTimeRanges.length-1;c>0;c--)b.disableTimeRanges[c][0]<=b.disableTimeRanges[c-1][1]&&(b.disableTimeRanges[c-1]=[Math.min(b.disableTimeRanges[c][0],b.disableTimeRanges[c-1][0]),Math.max(b.disableTimeRanges[c][1],b.disableTimeRanges[c-1][1])],b.disableTimeRanges.splice(c,1))}return b}function d(b){var c=b.data("timepicker-settings"),d=b.data("timepicker-list");if(d&&d.length&&(d.remove(),b.data("timepicker-list",!1)),c.useSelect){d=a("<select />",{"class":"ui-timepicker-select"});var f=d}else{d=a("<ul />",{"class":"ui-timepicker-list"});var f=a("<div />",{"class":"ui-timepicker-wrapper",tabindex:-1});f.css({display:"none",position:"absolute"}).append(d)}if(c.noneOption)if(c.noneOption===!0&&(c.noneOption=c.useSelect?"Time...":"None"),a.isArray(c.noneOption)){for(var h in c.noneOption)if(parseInt(h,10)==h){var i=e(c.noneOption[h],c.useSelect);d.append(i)}}else{var i=e(c.noneOption,c.useSelect);d.append(i)}c.className&&f.addClass(c.className),null===c.minTime&&null===c.durationTime||!c.showDuration||(f.addClass("ui-timepicker-with-duration"),f.addClass("ui-timepicker-step-"+c.step));var k=c.minTime;"function"==typeof c.durationTime?k=u(c.durationTime()):null!==c.durationTime&&(k=c.durationTime);var m=null!==c.minTime?c.minTime:0,n=null!==c.maxTime?c.maxTime:m+w-1;m>=n&&(n+=w),n===w-1&&"string"===a.type(c.timeFormat)&&-1!==c.timeFormat.indexOf("H")&&(n=w);for(var p=c.disableTimeRanges,q=0,v=p.length,h=m;n>=h;h+=60*c.step){var x=h,z=t(x,c.timeFormat);if(c.useSelect){var A=a("<option />",{value:z});A.text(z)}else{var A=a("<li />");A.data("time",86400>=x?x:x%86400),A.text(z)}if((null!==c.minTime||null!==c.durationTime)&&c.showDuration){var B=s(h-k,c.step);if(c.useSelect)A.text(A.text()+" ("+B+")");else{var C=a("<span />",{"class":"ui-timepicker-duration"});C.text(" ("+B+")"),A.append(C)}}v>q&&(x>=p[q][1]&&(q+=1),p[q]&&x>=p[q][0]&&x<p[q][1]&&(c.useSelect?A.prop("disabled",!0):A.addClass("ui-timepicker-disabled"))),d.append(A)}if(f.data("timepicker-input",b),b.data("timepicker-list",f),c.useSelect)b.val()&&d.val(g(b.val(),c)),d.on("focus",function(){a(this).data("timepicker-input").trigger("showTimepicker")}),d.on("blur",function(){a(this).data("timepicker-input").trigger("hideTimepicker")}),d.on("change",function(){o(b,a(this).val(),"select")}),o(b,d.val()),b.hide().after(d);else{var D=c.appendTo;"string"==typeof D?D=a(D):"function"==typeof D&&(D=D(b)),D.append(f),l(b,d),d.on("mousedown","li",function(){b.off("focus.timepicker"),b.on("focus.timepicker-ie-hack",function(){b.off("focus.timepicker-ie-hack"),b.on("focus.timepicker",y.show)}),j(b)||b[0].focus(),d.find("li").removeClass("ui-timepicker-selected"),a(this).addClass("ui-timepicker-selected"),r(b)&&(b.trigger("hideTimepicker"),f.hide())})}}function e(b,c){var d,e,f;return"object"==typeof b?(d=b.label,e=b.className,f=b.value):"string"==typeof b?d=b:a.error("Invalid noneOption value"),c?a("<option />",{value:f,"class":e,text:d}):a("<li />",{"class":e,text:d}).data("time",f)}function f(b,c){if(a.isNumeric(b)||(b=u(b)),null===b)return null;var d=b%(60*c.step);return d>=30*c.step?b+=60*c.step-d:b-=d,b}function g(a,b){return a=f(a,b),null!==a?t(a,b.timeFormat):void 0}function h(){return new Date(1970,1,1,0,0,0)}function i(b){var c=a(b.target),d=c.closest(".ui-timepicker-input");0===d.length&&0===c.closest(".ui-timepicker-wrapper").length&&(y.hide(),a(document).unbind(".ui-timepicker"))}function j(a){var b=a.data("timepicker-settings");return(window.navigator.msMaxTouchPoints||"ontouchstart"in document)&&b.disableTouchKeyboard}function k(b,c,d){if(!d&&0!==d)return!1;var e=b.data("timepicker-settings"),f=!1,g=30*e.step;return c.find("li").each(function(b,c){var e=a(c);if("number"==typeof e.data("time")){var h=e.data("time")-d;return Math.abs(h)<g||h==g?(f=e,!1):void 0}}),f}function l(a,b){b.find("li").removeClass("ui-timepicker-selected");var c=u(n(a),a.data("timepicker-settings"));if(null!==c){var d=k(a,b,c);if(d){var e=d.offset().top-b.offset().top;(e+d.outerHeight()>b.outerHeight()||0>e)&&b.scrollTop(b.scrollTop()+d.position().top-d.outerHeight()),d.addClass("ui-timepicker-selected")}}}function m(b,c){if(""!==this.value&&"timepicker"!=c){var d=a(this);if(d.data("timepicker-list"),!d.is(":focus")||b&&"change"==b.type){var e=u(this.value);if(null===e)return d.trigger("timeFormatError"),void 0;var f=d.data("timepicker-settings"),g=!1;if(null!==f.minTime&&e<f.minTime?g=!0:null!==f.maxTime&&e>f.maxTime&&(g=!0),a.each(f.disableTimeRanges,function(){return e>=this[0]&&e<this[1]?(g=!0,!1):void 0}),f.forceRoundTime){var h=e%(60*f.step);h>=30*f.step?e+=60*f.step-h:e-=h}var i=t(e,f.timeFormat);g?o(d,i,"error")&&d.trigger("timeRangeError"):o(d,i)}}}function n(a){return a.is("input")?a.val():a.data("ui-timepicker-value")}function o(a,b,c){if(a.is("input")){a.val(b);var d=a.data("timepicker-settings");d.useSelect&&"select"!=c&&a.data("timepicker-list").val(g(b,d))}return a.data("ui-timepicker-value")!=b?(a.data("ui-timepicker-value",b),"select"==c?a.trigger("selectTime").trigger("changeTime").trigger("change","timepicker"):"error"!=c&&a.trigger("changeTime"),!0):(a.trigger("selectTime"),!1)}function p(c){var d=a(this),e=d.data("timepicker-list");if(!e||!b(e)){if(40!=c.keyCode)return!0;y.show.call(d.get(0)),e=d.data("timepicker-list"),j(d)||d.focus()}switch(c.keyCode){case 13:return r(d)&&y.hide.apply(this),c.preventDefault(),!1;case 38:var f=e.find(".ui-timepicker-selected");return f.length?f.is(":first-child")||(f.removeClass("ui-timepicker-selected"),f.prev().addClass("ui-timepicker-selected"),f.prev().position().top<f.outerHeight()&&e.scrollTop(e.scrollTop()-f.outerHeight())):(e.find("li").each(function(b,c){return a(c).position().top>0?(f=a(c),!1):void 0}),f.addClass("ui-timepicker-selected")),!1;case 40:return f=e.find(".ui-timepicker-selected"),0===f.length?(e.find("li").each(function(b,c){return a(c).position().top>0?(f=a(c),!1):void 0}),f.addClass("ui-timepicker-selected")):f.is(":last-child")||(f.removeClass("ui-timepicker-selected"),f.next().addClass("ui-timepicker-selected"),f.next().position().top+2*f.outerHeight()>e.outerHeight()&&e.scrollTop(e.scrollTop()+f.outerHeight())),!1;case 27:e.find("li").removeClass("ui-timepicker-selected"),y.hide();break;case 9:y.hide();break;default:return!0}}function q(c){var d=a(this),e=d.data("timepicker-list");if(!e||!b(e))return!0;if(!d.data("timepicker-settings").typeaheadHighlight)return e.find("li").removeClass("ui-timepicker-selected"),!0;switch(c.keyCode){case 96:case 97:case 98:case 99:case 100:case 101:case 102:case 103:case 104:case 105:case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 65:case 77:case 80:case 186:case 8:case 46:l(d,e);break;default:return}}function r(a){var b=a.data("timepicker-settings"),c=a.data("timepicker-list"),d=null,e=c.find(".ui-timepicker-selected");if(e.hasClass("ui-timepicker-disabled"))return!1;if(e.length&&(d=e.data("time")),null!==d)if("string"==typeof d)a.val(d);else{var f=t(d,b.timeFormat);o(a,f,"select")}return!0}function s(a,b){a=Math.abs(a);var c,d,e=Math.round(a/60),f=[];return 60>e?f=[e,x.mins]:(c=Math.floor(e/60),d=e%60,30==b&&30==d&&(c+=x.decimal+5),f.push(c),f.push(1==c?x.hr:x.hrs),30!=b&&d&&(f.push(d),f.push(x.mins))),f.join(" ")}function t(b,c){if(null!==b){var d=new Date(v.valueOf()+1e3*b);if(!isNaN(d.getTime())){if("function"===a.type(c))return c(d);for(var e,f,g="",h=0;h<c.length;h++)switch(f=c.charAt(h)){case"a":g+=d.getHours()>11?x.pm:x.am;break;case"A":g+=d.getHours()>11?x.pm.toUpperCase():x.am.toUpperCase();break;case"g":e=d.getHours()%12,g+=0===e?"12":e;break;case"G":g+=d.getHours();break;case"h":e=d.getHours()%12,0!==e&&10>e&&(e="0"+e),g+=0===e?"12":e;break;case"H":e=d.getHours(),b===w&&(e=24),g+=e>9?e:"0"+e;break;case"i":var i=d.getMinutes();g+=i>9?i:"0"+i;break;case"s":b=d.getSeconds(),g+=b>9?b:"0"+b;break;case"\\":h++,g+=c.charAt(h);break;default:g+=f}return g}}}function u(a,b){if(""===a)return null;if(!a||a+0==a)return a;if("object"==typeof a)return 3600*a.getHours()+60*a.getMinutes()+a.getSeconds();a=a.toLowerCase(),("a"==a.slice(-1)||"p"==a.slice(-1))&&(a+="m");var c=new RegExp("^([0-2]?[0-9])\\W?([0-5][0-9])?\\W?([0-5][0-9])?\\s*("+x.am+"|"+x.pm+")?$"),d=a.match(c);if(!d)return null;var e=parseInt(1*d[1],10),f=d[4],g=e;12>=e&&f&&(g=12==e?d[4]==x.pm?12:0:e+(d[4]==x.pm?12:0));var h=1*d[2]||0,i=1*d[3]||0,j=3600*g+60*h+i;if(!f&&b&&b._twelveHourTime&&b.scrollDefault){var k=j-b.scrollDefault;0>k&&k>=w/-2&&(j=(j+w/2)%w)}return j}var v=h(),w=86400,x={am:"am",pm:"pm",AM:"AM",PM:"PM",decimal:".",mins:"mins",hr:"hr",hrs:"hrs"},y={init:function(b){return this.each(function(){var e=a(this),f=[];for(var g in a.fn.timepicker.defaults)e.data(g)&&(f[g]=e.data(g));var h=a.extend({},a.fn.timepicker.defaults,f,b);h.lang&&(x=a.extend(x,h.lang)),h=c(h),e.data("timepicker-settings",h),e.addClass("ui-timepicker-input"),h.useSelect?d(e):(e.prop("autocomplete","off"),e.on("click.timepicker focus.timepicker",y.show),e.on("change.timepicker",m),e.on("keydown.timepicker",p),e.on("keyup.timepicker",q),m.call(e.get(0)))})},show:function(c){var e=a(this),f=e.data("timepicker-settings");if(c){if(!f.showOnFocus)return!0;c.preventDefault()}if(f.useSelect)return e.data("timepicker-list").focus(),void 0;j(e)&&e.blur();var g=e.data("timepicker-list");if(!e.prop("readonly")&&(g&&0!==g.length&&"function"!=typeof f.durationTime||(d(e),g=e.data("timepicker-list")),!b(g))){y.hide(),g.show();var h={};h.left="rtl"==f.orientation?e.offset().left+e.outerWidth()-g.outerWidth()+parseInt(g.css("marginLeft").replace("px",""),10):e.offset().left+parseInt(g.css("marginLeft").replace("px",""),10),h.top=e.offset().top+e.outerHeight(!0)+g.outerHeight()>a(window).height()+a(window).scrollTop()?e.offset().top-g.outerHeight()+parseInt(g.css("marginTop").replace("px",""),10):e.offset().top+e.outerHeight()+parseInt(g.css("marginTop").replace("px",""),10),g.offset(h);var l=g.find(".ui-timepicker-selected");if(l.length||(n(e)?l=k(e,g,u(n(e))):f.scrollDefault&&(l=k(e,g,f.scrollDefault))),l&&l.length){var m=g.scrollTop()+l.position().top-l.outerHeight();g.scrollTop(m)}else g.scrollTop(0);return a(document).on("touchstart.ui-timepicker mousedown.ui-timepicker",i),f.closeOnWindowScroll&&a(document).on("scroll.ui-timepicker",i),e.trigger("showTimepicker"),this}},hide:function(){var c=a(this),d=c.data("timepicker-settings");return d&&d.useSelect&&c.blur(),a(".ui-timepicker-wrapper").each(function(){var c=a(this);if(b(c)){var d=c.data("timepicker-input"),e=d.data("timepicker-settings");e&&e.selectOnBlur&&r(d),c.hide(),d.trigger("hideTimepicker")}}),this},option:function(b,e){return this.each(function(){var f=a(this),g=f.data("timepicker-settings"),h=f.data("timepicker-list");if("object"==typeof b)g=a.extend(g,b);else if("string"==typeof b&&"undefined"!=typeof e)g[b]=e;else if("string"==typeof b)return g[b];g=c(g),f.data("timepicker-settings",g),h&&(h.remove(),f.data("timepicker-list",!1)),g.useSelect&&d(f)})},getSecondsFromMidnight:function(){return u(n(this))},getTime:function(a){var b=this,c=n(b);if(!c)return null;a||(a=new Date);var d=u(c),e=new Date(a);return e.setHours(d/3600),e.setMinutes(d%3600/60),e.setSeconds(d%60),e.setMilliseconds(0),e},setTime:function(a){var b=this,c=b.data("timepicker-settings");if(c.forceRoundTime)var d=g(a,c);else var d=t(u(a),c.timeFormat);return o(b,d),b.data("timepicker-list")&&l(b,b.data("timepicker-list")),this},remove:function(){var a=this;if(a.hasClass("ui-timepicker-input")){var b=a.data("timepicker-settings");return a.removeAttr("autocomplete","off"),a.removeClass("ui-timepicker-input"),a.removeData("timepicker-settings"),a.off(".timepicker"),a.data("timepicker-list")&&a.data("timepicker-list").remove(),b.useSelect&&a.show(),a.removeData("timepicker-list"),this}}};a.fn.timepicker=function(b){return this.length?y[b]?this.hasClass("ui-timepicker-input")?y[b].apply(this,Array.prototype.slice.call(arguments,1)):this:"object"!=typeof b&&b?(a.error("Method "+b+" does not exist on jQuery.timepicker"),void 0):y.init.apply(this,arguments):this},a.fn.timepicker.defaults={className:null,minTime:null,maxTime:null,durationTime:null,step:30,showDuration:!1,showOnFocus:!0,timeFormat:"g:ia",scrollDefault:null,selectOnBlur:!1,disableTouchKeyboard:!1,forceRoundTime:!1,appendTo:"body",orientation:"ltr",disableTimeRanges:[],closeOnWindowScroll:!1,typeaheadHighlight:!0,noneOption:!1}});
(function() {
  $(function() {
    var bottom_left_height, bottom_right_height, check_msg_info, check_present, generate_proxy_order, match_manager, match_student, open_box, open_proxy_box, submit_info;
    bottom_left_height = $('.bottom-left').height();
    bottom_right_height = $('.bottom-right .right-cont').height();
    if (bottom_left_height > bottom_right_height) {
      $('.bottom-right .right-cont').height(bottom_left_height);
    }
    $("#search_start,#search_end").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
    });
    $("#course_start_date,#course_end_date").datepicker({
      dateFormat: "yy-mm-dd",
      showAnim: 'show'
    });
    $('#course_start_time').timepicker({
      'timeFormat': 'h:i A',
      'step': 5
    });
    $('#course_end_time').timepicker({
      'timeFormat': 'h:i A',
      'step': 5
    });
    $('#course_description').ckeditor({});
    open_box = function() {
      return $.fancybox.open($('.msg-box'), {
        padding: 0,
        autoSize: true,
        scrolling: false,
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
        afterShow: function() {
          return $('#match_content_manager,#match_content_student,#box_notice_content,#box_course_notice_at').focus(function() {
            return $(this).parents('.one').removeClass('invalid');
          });
        }
      });
    };
    match_manager = function(obj, v) {
      var num;
      num = obj.parents('.one').next('.one').find('span.num');
      return $.get("/admin/courses/match_manager", {
        data: v
      }, function(ret) {
        if (ret.success) {
          $('#course_manager_condition').val(v);
          return num.text(ret.value + '人');
        }
      });
    };
    match_student = function(obj, v) {
      var num;
      num = obj.parents('.one').next('.one').find('span.num');
      return $.get("/admin/courses/match_student", {
        data: v
      }, function(ret) {
        if (ret.success) {
          $('#course_trainee_condition').val(v);
          return num.text(ret.value + '人');
        }
      });
    };
    check_msg_info = function() {
      var going;
      going = true;
      $('#match_content_manager,#match_content_student,#box_notice_content,#box_course_notice_at').each(function() {
        if (!($.trim($(this).val()).length > 0)) {
          $(this).closest('.one').addClass('invalid').removeClass('valid');
          return going = false;
        }
      });
      if (going) {
        return submit_info();
      }
    };
    submit_info = function() {
      $.fancybox.close();
      return $('form').submit();
    };
    check_present = function() {
      var go, publish;
      go = true;
      publish = parseInt($('#course_status').val());
      $('form.info input,select,textarea').each(function() {
        var top;
        if ($(this).attr('id') !== 'course_instructor_avatar') {
          if ($(this).is(":visible")) {
            if ($('#course_charge_category').val() === '1') {
              if ($.trim($(this).val()).length <= 0 && $.inArray($(this).attr('id'), ['course_price_level1', 'course_price_level2', 'course_price_level3']) < 0) {
                $(this).parent('.padded').addClass('invalid').removeClass('valid');
                go = false;
                top = $(this).offset().top;
                $("html, body").animate({
                  scrollTop: top
                }, 500);
                go = false;
                return false;
              }
            } else {
              if ($.trim($(this).val()).length <= 0) {
                $(this).parent('.padded').addClass('invalid').removeClass('valid');
                go = false;
                top = $(this).offset().top;
                $("html, body").animate({
                  scrollTop: top
                }, 500);
                go = false;
                return false;
              }
            }
          }
        }
      });
      if (go) {
        if (publish === 1) {
          return open_box();
        } else {
          return $('form').submit();
        }
      }
    };
    open_proxy_box = function(obj) {
      return $.fancybox.open($('.proxy-box'), {
        padding: 0,
        autoSize: true,
        minWidth: 800,
        minHeight: 500,
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
          $('.proxy-box h6').text(obj.parents('td').siblings('td.cname').text());
          $('.proxy-box #proxy_cid').val(obj.data('id'));
          $('.proxy-box .content .checklist').html('');
          return $('.proxy-box .multiple_proxy').attr('data-cid', obj.data('id'));
        }
      });
    };
    generate_proxy_order = function(id_arr, cid) {
      return $.post('/admin/orders/generate_proxy_order', {
        uarr: id_arr,
        cid: cid
      }, function(ret) {
        if (ret.success) {
          $('.select-tool').addClass('yellow');
          return $('.select-tool button').removeClass('info').addClass('success').text('报名成功');
        }
      });
    };
    $('form.info input,select,textarea').focus(function() {
      return $(this).parent('.padded').removeClass('invalid');
    });
    $('button.submit').click(function(e) {
      e.preventDefault();
      return check_present();
    });
    $('body').on('change', '#match_content_manager', function() {
      var m_v;
      m_v = $(this).val();
      return match_manager($(this), m_v);
    });
    $('body').on('change', '#match_content_student', function() {
      var m_s;
      m_s = $(this).val();
      return match_student($(this), m_s);
    });
    $('body').on('keyup', '#box_notice_content', function() {
      var remain, v;
      v = $(this).val();
      remain = 72 - v.length;
      $('i.remain').text(remain);
      return $('#course_notice_content').val(v);
    });
    $('body').on('keyup', '#box_course_notice_at', function() {
      var notice_at;
      notice_at = $(this).val();
      return $('#course_notice_at').val(notice_at);
    });
    $('body').on('click', '.box_button', function() {
      return check_msg_info();
    });
    $('body').on('click', '.pagination a', function() {
      var city, code, content, end, g_data, name, page, start, status;
      if (!$(this).hasClass('disabled')) {
        page = $(this).data('page');
        code = $(this).data('code');
        name = $(this).data('name');
        start = $(this).data('start');
        end = $(this).data('end');
        content = $(this).data('content');
        city = $(this).data('city');
        status = $(this).data('status');
        g_data = {
          page: page,
          code: code,
          name: name,
          start: start,
          end: end,
          content: content,
          city: city,
          status: status
        };
        if (page) {
          return $.get("/admin/courses", g_data, function() {});
        }
      }
    });
    $('body').on('click', 'a.proxy', function() {
      return open_proxy_box($(this));
    });
    $('body').on('click', '.multiple_proxy', function(e) {
      e.preventDefault();
      return $.get("/admin/courses/proxy_search", $('form.proxy-form').serialize(), function(ret) {
        $('.proxy-box .content .checklist').html('');
        return $.each(ret.value, function(k, v) {
          if (v.ordered) {
            return $("<li class='turquoise one fourth' data-uid=" + v.uid + " data-ordered=1 aria-checked='true'>" + v.name + "</li>").appendTo($('.proxy-box .content .checklist'));
          } else {
            return $("<li class='turquoise one fourth' data-uid=" + v.uid + " data-ordered=0>" + v.name + "</li>").appendTo($('.proxy-box .content .checklist'));
          }
        });
      });
    });
    $('body').on('click', '.select-tool li', function() {
      if ($(this).attr('aria-checked') === 'true') {
        return $('.content .checklist li[data-ordered="0"]').attr('aria-checked', true);
      } else {
        return $('.content .checklist li[data-ordered="0"]').attr('aria-checked', false);
      }
    });
    return $('body').on('click', 'button.multiple_proxy', function() {
      var cid, id_arr;
      cid = $(this).data('cid');
      if ($('.content .checklist li[aria-checked="true"]').length > 0) {
        id_arr = [];
        $('.content .checklist li[aria-checked="true"]').each(function() {
          return id_arr.push($(this).data('uid'));
        });
        if (id_arr.length > 0) {
          return generate_proxy_order(id_arr, cid);
        }
      }
    });
  });

}).call(this);
