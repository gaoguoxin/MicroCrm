$(->
  $('body').on('click','a.allow',->
    course_id = $(@).data('cid')
    user_id   = $(@).data('uid')
    type      = 'allow'
    handle_order($(@),course_id,user_id,type)
  )

  $('body').on('click','a.refuse',->
    course_id = $(@).data('cid')
    user_id   = $(@).data('uid')
    type      = 'refuse'
    handle_order($(@),course_id,user_id,type)
  )


  $('body').on('click','a.cancel',->
    oid = $(@).data('oid')
    $.get('/manager/orders/cancel',{id:oid},(ret)->
      if ret.success
        window.location.reload()
    )
  )

  handle_order = (obj,cid,uid,type)->
    $.get('/manager/orders/check',{cid:cid,uid:uid,type:type},(ret)->
      if ret.success
        window.location.reload()
    )


)
