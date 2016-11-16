$(document).ready ->
  $('.ui.rating').rating();
  $('.ui.dropdown').dropdown();
  $('.ui.accordion').accordion();
  $('.ui.radio.checkbox').checkbox();
  $('#sign_up').click ->
    $('#sign_up_modal').modal('show')
  $('#login').click ->
    $('#login_modal').modal('show')
  $(document).on 'click','.navbar-collapse.in',(e) ->
    if $(e.target).is('a')
      $(this).collapse('hide')
