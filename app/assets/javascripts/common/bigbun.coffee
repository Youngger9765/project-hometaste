$(document).ready ->
  $(document).on 'click','.bigbun.after_prepartion', (e) ->
    e.preventDefault()
    if location.pathname == '/'
      id = $(this).closest('.ui.card').data('id')
      $('#bigbun_modal_'+id ).modal('show')

