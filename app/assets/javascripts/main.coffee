$(document).ready ->
  $('.ui.rating').rating('disable');

 #---------card column modify ---------------

  modify_card_column=() ->
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

  modify_card_column()

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


  # -------------- load more controller  --------------

  $('#load_more').click ->
    load_more_times += 1
    cards_num()
    render_food_card(cards_num() * load_more_times)

  # -------------- switch map --------------

  $('p[name="more_cuisine"]').click ->
    $('.ui.modal[name="more_cuisine"]').modal('show');

  $(document).on('click','.foods div[data-tooltip="Address"]', ->
    $(this).siblings('.address_detail').toggleClass('hidden')
    $(this).find('i').toggleClass('black')
  )

  $('div[data-tooltip="Map view"],div[data-tooltip="Product list"]').click ->
    $('div[data-tooltip="Product list"],div[data-tooltip="Map view"]').toggleClass('hidden')
    $('.foods.cards , .location_map').toggleClass('hidden')
    if $(this).data('tooltip') == 'Map view'
      render_google_map()

  # --------------- google map function define -------------

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
    location = $('#location_input').val();
    $.ajax
      type: 'GET',
      url: '/api/v1/search/keyword',
      data:{keyword:keyword,location:location},
      complete:->
        modify_card_column()
        render_food_card(cards_num())


  #----------------- filter ---------------------

  filter_ajax=() ->
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
      data:{ checked_list: checked_list_name }

  check_checkbox_status=() ->
    if ($(this).attr('id') == 'any_cuisine') && ($('#any_cuisine input').prop('checked') == true)
      $('.cuisine_grouped .ui.checkbox:not(#any_cuisine)').checkbox('uncheck')
    else if $(this).attr('id') != 'any_cuisine'
      $('#any_cuisine').checkbox('uncheck')

  $('.cuisine_grouped .ui.checkbox').click ->
    check_checkbox_status.bind(this)()

  $('.distance_input').on 'change',() ->
    $(this).find('label').html( $(this).find('#distance_input').val() );

  $('.distance_input').focusout ->
    filter_ajax()

  $('.distance_input').keypress (event)->
    if ( event.which == 13 )
      filter_ajax()
      $(this).find('input').blur();

  $('.filter_menu .ui.checkbox:not(.distance_input)').change ->
    filter_ajax()

  $('#cuisine_modal_btn').click ->
    filter_ajax()
    $('.ui.small.modal').modal('hide');





