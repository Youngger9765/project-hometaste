$(document).ready ->
  $('.ui.rating').rating('disable');
  $('.cards .col-xs-6:odd').addClass('padding_left_7_xs')
  $('.cards .col-xs-6:even').addClass('padding_right_7_xs')
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
      $(this).parent().after("<div class='clearfix visible-sm visible-xs'></div>")
    if (index+1) % 3 == 0
      $(this).parent().after("<div class='clearfix hidden-sm hidden-xs'></div>")

# ------ show and check card num -----------

  load_more_times = 1

  card_num=() ->
    if $(window).width() < 992
      num = 8
    else
      num = 9
    console.log(num)
    return num

  render_product_card=(num) ->
    card = $('.card:lt('+num+')')
    card.show()
    $('.card:lt('+num+') img').each ->
      $(this).attr('src',$(this).attr("data-src"))

  render_product_card(card_num())

  $(window).resize ->
    card_num()
    render_product_card(card_num() * load_more_times)

  $('#load_more').click ->
    load_more_times += 1
    card_num()
    render_product_card(card_num() * load_more_times)

# ------------------------------------------

  $('p[name="more_cuisine"]').click ->
    $('.ui.modal[name="more_cuisine"]').modal('show');

  $('div[data-tooltip="Address"]').click ->
    $(this).siblings('.address_detail').toggleClass('hidden')
    $(this).find('i').toggleClass('black')

  $('div[data-tooltip="Map view"],div[data-tooltip="Product list"]').click ->
    $('div[data-tooltip="Map view"]').toggleClass('hidden')
    $('div[data-tooltip="Product list"]').toggleClass('hidden')
    $('.products.cards').toggleClass('hidden')
    $('.location_map').toggleClass('hidden')


