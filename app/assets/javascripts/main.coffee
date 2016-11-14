$(document).ready ->
  $('.card').each (index) ->
    button = $(this).find('.custom.button')
    popup = $(this).find('.custom.popup')
    button.popup({
        popup: popup,
    position: 'top right',
    hoverable: true
    })
    $(this).hover ->
      $(this).find('.card_hover_link').toggleClass('hidden')
    if (index+1) % 2 == 0
      $(this).parent().after("<div class='clearfix visible-sm'></div>")
    if (index+1) % 3 == 0
      $(this).parent().after("<div class='clearfix hidden-sm'></div>")


  $('p[name="more_cuisine"]').click ->
    $('.ui.small.modal').modal('show');

  $('div[data-tooltip="Address"]').click ->
    $(this).siblings('.address_detail').toggleClass('hidden')
    $(this).find('i').toggleClass('black')

  $('div[data-tooltip="Map view"],div[data-tooltip="Product list"]').click ->
    $('div[data-tooltip="Map view"]').toggleClass('hidden')
    $('div[data-tooltip="Product list"]').toggleClass('hidden')
    $('.product_cards').toggleClass('hidden')
    $('.location_map').toggleClass('hidden')


