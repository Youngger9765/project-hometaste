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