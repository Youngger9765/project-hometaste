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
  cards_qty = 9
  cards_num=() ->
    if $(window).width() < 992
      cards_qty = 8
    return cards_qty

  render_food_card=(num) ->
    card = $('.card:lt('+num+')')
    card.addClass('visible')
    $('.card:lt('+num+') img').each ->
      $(this).attr('src',$(this).attr("data-src"))

  render_food_card(cards_num())

  $(window).resize ->
    cards_num()
    render_food_card(cards_num() * load_more_times)

  $('#load_more').click ->
    load_more_times += 1
    cards_num()
    render_food_card(cards_num() * load_more_times)

  # -------------- switch map --------------

  $('p[name="more_cuisine"]').click ->
    $('.ui.modal[name="more_cuisine"]').modal('show');

  $('div[data-tooltip="Address"]').click ->
    $(this).siblings('.address_detail').toggleClass('hidden')
    $(this).find('i').toggleClass('black')

  $('div[data-tooltip="Map view"],div[data-tooltip="Product list"]').click ->
    $('div[data-tooltip="Map view"]').toggleClass('hidden')
    $('div[data-tooltip="Product list"]').toggleClass('hidden')
    $('.foods.cards').toggleClass('hidden')
    $('.location_map').toggleClass('hidden')
    render_google_map()

  # --------------- google map -------------

  get_cards_id=() ->
    ids = []
    qty = - cards_qty - 1
    $(".card.visible:gt(" + qty + ")").each () ->
      ids.push( $(this).data('id') )
    return ids

  render_google_map=() ->
    $.ajax
      type: 'GET',
      url: '/api/v1/getDishesByFilter',
      data:{ids:get_cards_id()},
      success: (data)->
        buildMap(data.gmap_hash)

  # ----------------- search -------------------

  $('.menu .item').mouseover ->
    $('#keyword_input').val($(this).html())

  $('#search_submit').click ->
    keyword = $('#keyword_input').val()
    near = $('#near_input').val();
    $.ajax
      type: 'GET',
      url: '/api/v1/search/keyword',
      data:{keyword:keyword,near:near}

  #----------------- filter ---------------------

  $('.ui.checkbox').change ->
    checked_list_name = {}

    checked_list = $(':checked').siblings('label')

    $.each(checked_list , ->
      p_html = $(this).closest('.grouped').siblings('p').html();
      if checked_list_name["#{ p_html }"] == undefined
        checked_list_name["#{ p_html }"] = []
      checked_list_name["#{ p_html }"].push($(this).html())
    )

    $.ajax
      type: 'GET',
      url: '/api/v1/search/filter',
      data:{ checked_list_name: checked_list_name },
      success:(data)->
        console.log(checked_list_name)




