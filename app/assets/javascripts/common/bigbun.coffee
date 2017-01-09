$(document).ready ->
  $(document).on 'click','.bigbun.after_prepartion', (e) ->
    e.preventDefault()
    if location.pathname == '/'
      console.log(123);
      id = $(this).closest('.ui.card').data('id')
      console.log(id);
      $('#bigbun_modal_'+id ).modal('show')

