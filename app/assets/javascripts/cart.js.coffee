$(document).ready ->

  get_cart_list=() ->
    if $.cookie('cart_list') == undefined
      {}
    else
      $.parseJSON( $.cookie('cart_list') )

  in_order_new=() ->
    location.pathname.indexOf("orders/new") > -1

  save_in_cookie=( data ) ->
    $.cookie('cart_list', JSON.stringify(data), { expires: 1, path: '/' } )

  order_type_is_Delivery=() ->
    $('#order_shipping_dropdown').dropdown('get value')[0] == 'Delivery'

  catch_params_date=() ->
    date = /\?date=.*(\d{4}).*-.*(\d{2}).*-.*(\d{2}).*&?/.exec(location.search);
    if date
      return (date[1] + '-' + date[2] + '-' + date[3])

  get_restautant_id_by_path = ->
    +/restaurants\/(\d+)\//.exec(location.pathname)[1]

  check_advance_status=() ->
    today = new Date($('body').data('current-date'))
    params_date = new Date($('body').data('order-date'))
    if params_date > today
      true
    else if $('.add_to_cart').size() > 0
      $('.add_to_cart').attr('class').indexOf('advance') != -1
    else
      false

  cart_empty=() ->
    Object.keys(get_cart_list()).length == 0

  cart_zero=()->
    +$('.add_to_cart [name=cart_total_price]').html() == 0

  now_advance_date=() ->
    if check_advance_status
      $('.advance_food').data('advance-time')
    else
      ''

#    if true will return time, or false
  get_advance_date=(food) ->
    if food.indexOf("advance_food") == 0 && /advance_food_\d+_(\d+-\d+-\d+)/.exec(food)
      /advance_food_\d+_(\d+-\d+-\d+)/.exec(food)[1]
    else
      false

  valid_advance_food_by_params_date=(food)->
    if get_advance_date(food) == catch_params_date()
      true
    else false

  get_advance_id=(food) ->
    +/advance_food_(\d+)_/.exec(food)[1]

  render_food_qty = () ->
    list = get_cart_list()
    Object.keys(list).forEach (restaurant,i,a) ->
      Object.keys(list[restaurant]).forEach (food,i,a) ->

        if get_advance_date(food)  #如果是advance的話就render advance的數量  不是advance就是today
          qty = +list[restaurant][food]['qty']
          id = get_advance_id(food)
          $('.advance_food[data-food-id="' + id + '"][data-advance-time="'+get_advance_date(food)+'"]').find('#txtNum').val(qty)

        else if food.indexOf("food") == 0
          qty = +list[restaurant][food]['qty']
          id = +food.replace('food_','')
          $(':not(.advance_food)[data-food-id="' + id + '"]').find('#txtNum').val(qty)


  deal_bigbun_list=(_this) ->
    modal = $(_this).closest('.bigbun_modal')
    bigbun_id = modal.data('bigbun-id')
    img_url = modal.find('img').attr('src')
    restaurant_id = modal.data('restaurant-id')
    bigbun_code = modal.find('#bigbun_code').html()
    prepare_time = modal.data('prepare-time')
    stop_time = modal.data('stop-time')

    info_object = get_cart_list() || {}
    if info_object["restaurant_#{restaurant_id}"]
      info_object["restaurant_#{restaurant_id}"]["bigbun_#{bigbun_id}"] =
        bigbun_code: bigbun_code,
        img_url: img_url,
        prepare_time: prepare_time,
        stop_time: stop_time
    else
      info_object["restaurant_#{restaurant_id}"] =
        "bigbun_#{bigbun_id}":
          img_url: img_url,
          bigbun_code: bigbun_code,
          prepare_time: prepare_time,
          stop_time: stop_time

    save_in_cookie(info_object)


  #    需判斷today advance 區分兩個資料結構 此fucntion是處理存儲或刪除 food
  deal_food_list=(_this) ->
    advance = ''
    img_url = ''
    advance_time = ''
    _data = $(_this).closest('.food_data_info')
    restaurant_id = _data.data('restaurant-id')
    restaurant_tax = parseFloat(_data.data('restaurant-tax'))
    restaurant_cost = _data.data('restaurant-cost')
    restaurant_distance = parseFloat(_data.data('restaurant-distance'))
    food_id = _data.data('food-id')
    food_price = parseFloat(_data.data('food-price'))
    name = _data.data('food-name')
    qty = +$(_this).siblings('#txtNum').val()
    img = $('[data-food-pic="' + food_id + '"]').first().css('background-image');

    if _data.data('advance-time')
      advance_time = '_' + _data.data('advance-time')

    if check_advance_status() #預設都是 today 如果發現是 advance 就在資料前加 advance
      advance = 'advance_'

    if img
      img_url = img.replace('url(','').replace(')','').replace(/\"/gi, "");

    info_object = get_cart_list()
    if qty > 0
      if info_object["restaurant_#{restaurant_id}"]
        info_object["restaurant_#{restaurant_id}"]["#{advance}food_#{food_id + advance_time}"] =
          qty:qty,
          price:food_price
          img_url:img_url
          name:name
      else
        info_object["restaurant_#{restaurant_id}"] =
          "#{advance}food_#{food_id + advance_time}":
            qty:qty,
            price:food_price
            img_url:img_url
            name:name

      info_object["restaurant_#{restaurant_id}"]['tax'] = restaurant_tax
      info_object["restaurant_#{restaurant_id}"]['cost'] = restaurant_cost
      info_object["restaurant_#{restaurant_id}"]['restaurant_distance'] = restaurant_distance
    else if qty == 0
      if info_object.hasOwnProperty("restaurant_#{restaurant_id}")
        if info_object["restaurant_#{restaurant_id}"].hasOwnProperty("#{advance}food_#{food_id}")
          delete info_object["restaurant_#{restaurant_id}"]["#{advance}food_#{food_id}"]
          if Object.keys(info_object["restaurant_#{restaurant_id}"]).length == 0
            delete info_object["restaurant_#{restaurant_id}"]

    save_in_cookie(info_object)


  render_order_new_list=() ->
    if cart_empty()
      alert_message(window.alert_text= 'You need to buy some food!')
      return
    advance = ''
    params_date = ''
    product_list = $('.product_list').first()
    advance_status = check_advance_status()
    cart_list = get_cart_list()
    restaurant_id = +(/\/(\d+)\//gi).exec(location.pathname)[1]
    current_restaurant = cart_list["restaurant_#{restaurant_id}"]

    Object.keys(current_restaurant).forEach (food,i,a) ->
      if food.indexOf('food') == -1
        return
      if advance_status
        if valid_advance_food_by_params_date(food)
          advance = 'advance_'
          params_date = '_' + catch_params_date()
          valid_food = food
        else
          return
      else if food.indexOf("food") == 0
        valid_food = food
      else
        return

      product_list.clone().insertAfter('.product_list:last');
      this_list = $('.product_list:last')
      this_list.removeClass('hidden')
      restaurant_tax = +current_restaurant['tax']
      food_id = +/food_(\d+)/.exec(valid_food)[1]
      qty = +current_restaurant[valid_food]['qty']
      name = current_restaurant[valid_food]['name']
      img_url = current_restaurant[valid_food]['img_url']
      price = +current_restaurant[valid_food]['price']

      this_list.find('[name=food_price]').html(price)
      this_list.find('[name=food_name]').html(name)
      this_list.find('#txtNum').val(qty)
      this_list.find('.food_data_info')
        .attr('data-food-name',name)
        .attr('data-food-id',food_id)
        .attr('data-food-price',price)
        .attr('data-restaurant-id',restaurant_id)
        .attr('data-restaurant-tax',restaurant_tax)

    product_list.remove()  #清掉第一個被拿來clone的

  render_total_price=() ->
    cart_list = get_cart_list()
    tax_price = 0
    food_price = 0
    date = ''
    advance = ''
    date = '_' + now_advance_date()

    if check_advance_status() #判斷是否為 advance
      advance = 'advance_'

    restaurant_id = $('[data-restaurant-id]').data('restaurant-id')
    current_restaurant = cart_list["restaurant_#{restaurant_id}"]
    if current_restaurant
      restaurant_tax = +current_restaurant['tax']

      Object.keys(current_restaurant).forEach (food,i,a) ->
        if check_advance_status()
          if valid_advance_food_by_params_date(food)
            qty = +current_restaurant[food]['qty']
            price = +current_restaurant[food]['price']
            food_price += qty * price
        else
          if food.indexOf("food") == 0
            qty = +current_restaurant[food]['qty']
            price = +current_restaurant[food]['price']
            food_price += qty * price

    tax_price += food_price * restaurant_tax / 100 || 0
    tip = parseFloat( $('input.tip_input').val() ) || 0
    total_price = (tax_price + food_price + tip) || 0
    $('[name=subtotal]').html(food_price.toFixed(2))
    $('[name=tax]').html(tax_price.toFixed(2))
    $('[name=alltotal]').html(total_price.toFixed(2))
    $('[name=cart_total_price]').html(food_price.toFixed(2))


  # food qty up or down 不計算加減，每點一次就撈一次現值
  $(document).on 'click', ".product_spineer_button" , ->
    deal_food_list(this)
    render_total_price()

  # bigbun add
  $(document).on 'click', ".bigbun_modal #redeem_now" , ->
    deal_bigbun_list(this)
    $('.bigbun_modal').modal('hide')


  #-----------       order new page render     ---------------------
  if in_order_new()
    render_order_new_list()
    render_total_price()

    $('.orders_new form').submit (e)->
      e.preventDefault()
      if cart_empty() || cart_zero()
        alert_message(window.alert_text= 'You need to buy some food!')
        return
      else if order_type_is_Delivery() && window.order_location_invalid
        alert_message(window.alert_text= "Enter valid location, or can't next action!")
        return
      else
        advance = ''
        form = $('.orders_new form')
        data = form.serialize()
        cart_list = get_cart_list()
        restaurant_id = get_restautant_id_by_path()
        current_restaurant = cart_list["restaurant_#{restaurant_id}"]

        $('[name="order[pick_up_time]"]').parents('.hidden').remove()  #前端有兩個pick up time 要刪掉隱藏的那個
        $('[name="order[shipping_place]"]').parents('.hidden').remove()  #前端有兩個location 要刪掉隱藏的那個

        $.each $('.food_data_info'),(index,food) ->
          qty = +$(food).find('input[type=text]').val()
          food_id = $(food).data('food-id')
          form.append($("<input>").attr("type", "hidden").attr("name", "order[order_food_ships_attributes]["+index+"][food_id]").val(food_id));
          form.append($("<input>").attr("type", "hidden").attr("name", "order[order_food_ships_attributes]["+index+"][quantity]").val(qty));

        form.append($("<input>").attr("type", "hidden").attr("name", "order[restaurant_id]").val(restaurant_id));
        if $('.bigbun_list').data('bigbun-id') != -1
          form.append($("<input>").attr("type", "hidden").attr("name", "order[bigbun-id]").val($('.bigbun_list').data('bigbun-id')));
#        Object.keys(current_restaurant).forEach (_key,i,a) ->
#          if _key.indexOf('bigbun') != -1
#            code = cart_list["#{restaurant}"]["#{_key}"]
#            bigbun_id = +_key.replace('bigbun_','')
#            input = $("<input>").attr("type", "hidden").attr("name", "bigbun[#{bigbun_id}]").val(code);
#            form.append($(input));

        #      $.removeCookie('cart_list',{path:'/'})
        $(this).off('submit').submit();

  if !in_order_new()
    render_food_qty()
    render_total_price()

#  打包出去給全域用
  window.render_food_qty = -> render_food_qty()
  window.deal_food_list = -> deal_food_list()
  window.render_total_price = -> render_total_price()
  window.get_cart_list = -> get_cart_list()
