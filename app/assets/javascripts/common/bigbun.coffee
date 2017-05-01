$(document).ready ->
  $(document).on 'click','.bigbun.after_prepartion', (e) ->
    e.preventDefault()
    if location.pathname == '/'
      id = $(this).closest('.ui.card').data('id')
      $('#bigbun_modal_'+id ).modal('show')
    else if location.pathname.match(/(restaurants\/\d+)/gi)
      $('.bigbun_modal').modal('show')

  $(document).on 'click','.bigbun.before_prepartion', (e) ->
    e.preventDefault()

  $(document).on 'click', ".bigbun_modal #redeem_now,.bigbun_modal #use_later" , ->
    parent = $(this).parents('.bigbun_modal')
    $.ajax
      type: 'POST',
      url: '/big_buns/user_get_big_bun',
      data:{ big_bun_id: parent.data('bigbun-id') }
    parent.modal('hide')

  $(document).on 'click', ".bigbun_modal #send_gift" , ->
    $('.gift_email_modal').modal('show')

  $(document).on 'click', "#send_gift_confirmation" , ->
    parent = $(this).parents('.gift_email_modal')
    $.ajax
      type: 'POST',
      url: '/big_buns/user_send_big_bun_as_gift',
      data:
        big_bun_id: parent.data('bigbun-id'),
        email: parent.find('input').val()

    parent.modal('hide')