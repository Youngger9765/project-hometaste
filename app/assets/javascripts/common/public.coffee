$(document).ready ->
  $('.dropdown-toggle').dropdown()
  $('.ui.dropdown').dropdown('refresh');
  $('.ui.checkbox').checkbox();
  $('.ui.accordion').accordion();
  $('.ui.radio.checkbox').checkbox();
  $('.sign_up').click ->
    $('#sign_up_modal').modal('show')
  $('.login').click ->
    $('#login_modal').modal('show')
  $(document).on 'click','.navbar-collapse.in',(e) ->
    if $(e.target).is('a')
      $(this).collapse('hide')


  $('.alert_message .close').on 'click', ->
    $('.alert_message').addClass('hidden')

  alert_message=() ->
    $('#alert_notice').parents('.alert_message').removeClass('hidden')
    $('#alert_notice p').html(alert_text)

  window.alert_message = -> alert_message()
  window.alert_text = ''