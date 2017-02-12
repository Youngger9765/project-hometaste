$(document).ready ->

  get_cart_list=() ->
    if $.cookie('cart_list') == undefined
      {}
    else
      $.parseJSON( $.cookie('cart_list') )


  save_in_cookie=( data ) ->
    $.cookie('cart_list', JSON.stringify(data), { expires: 1, path: '/' } )


  render_food_qty=() ->
    list = get_cart_list()
    Object.keys(list).forEach (restaurant,i,a) ->
      Object.keys(list["#{restaurant}"]).forEach (food,i,a) ->
        if food.indexOf('food') != -1
          qty = +list["#{restaurant}"]["#{food}"]['qty']
          id = +food.replace('food_','')
          $("[data-food-id='" + id + "']").find('#txtNum').val(qty)


  deal_bigbun_list=(_this) ->
    modal = $(_this).closest('.bigbun_modal')
    bigbun_id = modal.data('bigbun-id')
    restaurant_id = modal.data('restaurant-id')
    bigbun_code = modal.find('#bigbun_code').html()

    info_object = get_cart_list() || {}
    if info_object["restaurant_#{restaurant_id}"]
      info_object["restaurant_#{restaurant_id}"]["bigbun_#{bigbun_id}"] = bigbun_code
    else
      info_object["restaurant_#{restaurant_id}"] =
        "bigbun_#{bigbun_id}":bigbun_code

    save_in_cookie(info_object)


  deal_food_list=(_this) ->
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
    if img
      img_url = img.replace('url(','').replace(')','').replace(/\"/gi, "");
    else
      img_url = ''

    info_object = get_cart_list()
    if qty > 0
      if info_object["restaurant_#{restaurant_id}"]
        info_object["restaurant_#{restaurant_id}"]["food_#{food_id}"] =
          qty:qty,
          price:food_price
          img_url:img_url
          name:name
      else
        info_object["restaurant_#{restaurant_id}"] =
          "food_#{food_id}":
            qty:qty,
            price:food_price
            img_url:img_url
            name:name

      info_object["restaurant_#{restaurant_id}"]['tax'] = restaurant_tax
      info_object["restaurant_#{restaurant_id}"]['cost'] = restaurant_cost
      info_object["restaurant_#{restaurant_id}"]['restaurant_distance'] = restaurant_distance
    else if qty == 0
      if info_object.hasOwnProperty("restaurant_#{restaurant_id}")
        if info_object["restaurant_#{restaurant_id}"].hasOwnProperty("food_#{food_id}")
          delete info_object["restaurant_#{restaurant_id}"]["food_#{food_id}"]
          if Object.keys(info_object["restaurant_#{restaurant_id}"]).length == 0
            delete info_object["restaurant_#{restaurant_id}"]

    save_in_cookie(info_object)
  #    return restaurant_id:restaurant_id,food_id:food_id,food_price:food_price,qty:qty,info_object:info_object


  render_order_new_list=() ->
    product_list = $('.product_list').first()
    cart_list = get_cart_list()
    restaurant_id = +location.pathname.match(/\/\d+\//gi)[0].replace(/\//g,'')
#    Object.keys(cart_list).forEach (restaurant,i,a) ->
    current_restaurant = cart_list["restaurant_#{restaurant_id}"]
    Object.keys(current_restaurant).forEach (food,i,a) ->
      if food.indexOf('food') != -1
        if i != 0
          product_list.clone().insertAfter('.product_list:last');

        this_list = $('.product_list:last')
        this_list.removeClass('hidden')
#        restaurant_id = +restaurant.replace('restaurant_','')
        restaurant_tax = +current_restaurant['tax']
        food_id = +food.replace('food_','')
        qty = +current_restaurant["#{food}"]['qty']
        name = current_restaurant["#{food}"]['name']
        img_url = current_restaurant["#{food}"]['img_url']
        price = +current_restaurant["#{food}"]['price']

        this_list.find('[name=food_price]').html(price)
        this_list.find('[name=food_name]').html(name)
        this_list.find('#txtNum').val(qty)
        this_list.find('.food_data_info')
          .attr('data-food-name',name)
          .attr('data-food-id',food_id)
          .attr('data-food-price',price)
          .attr('data-restaurant-id',restaurant_id)
          .attr('data-restaurant-tax',restaurant_tax)


  render_total_price=() ->
    cart_list = get_cart_list()
    tax_price = 0
    food_price = 0
    restaurant_id = $('[data-restaurant-id]').data('restaurant-id')
    current_restaurant = cart_list["restaurant_#{restaurant_id}"]
    if current_restaurant
      restaurant_tax = +current_restaurant['tax']

      Object.keys(current_restaurant).forEach (food,i,a) ->
        if food.indexOf('food') != -1
          qty = +current_restaurant["#{food}"]['qty']
          price = +current_restaurant["#{food}"]['price']
          tax_price += qty * price * restaurant_tax / 100
          food_price += qty * price


    tip = parseFloat( $('input.tip_input').val() ) || 0
    total_price = (tax_price + food_price + tip) || 0
    $('[name=subtotal]').html(food_price.toFixed(2))
    $('[name=tax]').html(tax_price.toFixed(2))
    $('[name=alltotal]').html(total_price.toFixed(2))
    $('[name=cart_total_price]').html(food_price.toFixed(2))

#    Object.keys(cart_list).forEach (restaurant,i,a) ->
#    restaurant_tax = +cart_list["#{restaurant}"]['tax']
#    Object.keys(cart_list["#{restaurant}"]).forEach (food,i,a) ->
#      if food.indexOf('food') != -1
#        qty = +cart_list["#{restaurant}"]["#{food}"]['qty']
#        price = +cart_list["#{restaurant}"]["#{food}"]['price']
#        tax_price += qty * price * restaurant_tax / 100
#        food_price += qty * price
#    tip = parseFloat( $('input.tip_input').val() )
#    total_price = (tax_price + food_price )
#    $('[name=subtotal]').html(food_price.toFixed(2))
#    $('[name=tax]').html(tax_price.toFixed(2))
#    $('[name=alltotal]').html(total_price.toFixed(2))
#    $('[name=cart_total_price]').html(food_price.toFixed(2))

  render_food_qty()
  if location.pathname.replace(/restaurants\/\d*\//gi,'') != "/orders/new"
    render_total_price()


  # food qty up or down 不計算加減，每點一次就撈一次現值
  $(document).on 'click', ".product_spineer_button" , ->
    deal_food_list(this)
    render_total_price()
    if location.pathname == "/orders/new"
      render_total_price()
  # bigbun add
  $(document).on 'click', ".bigbun_modal #redeem_now" , ->
    deal_bigbun_list(this)
    $('.bigbun_modal').modal('hide')

  #-----------       order new page render     ---------------------
  if location.pathname.replace(/restaurants\/\d*\//gi,'') == "/orders/new"
    render_order_new_list()
    render_total_price()
    $('input.tip_input').change ->
      render_total_price()

    $('.orders_new form').submit (e)->
      e.preventDefault()
      if !!+$('.add_to_cart [name=cart_total_price]').html()
        form = $('.orders_new form')
        data = form.serialize()
        cart_list = get_cart_list()
        Object.keys(cart_list).forEach (restaurant,i,a) ->

          restaurant_id = +restaurant.replace('restaurant_','')
          input = $("<input>").attr("type", "hidden").attr("name", "order[restaurant_id]").val(restaurant_id);
          form.append($(input));

          Object.keys(cart_list["#{restaurant}"]).forEach (_key,i,a) ->

            if _key.indexOf('food') != -1
              qty = +cart_list["#{restaurant}"]["#{_key}"]['qty']
              food_id = +_key.replace('food_','')
              input = $("<input>").attr("type", "hidden").attr("name", "food[#{food_id}]").val(qty);
              form.append($(input));

            else if _key.indexOf('bigbun') != -1
              code = cart_list["#{restaurant}"]["#{_key}"]
              bigbun_id = +_key.replace('bigbun_','')
              input = $("<input>").attr("type", "hidden").attr("name", "bigbun[#{bigbun_id}]").val(code);
              form.append($(input));

        #      $.removeCookie('cart_list',{path:'/'})
        $(this).off('submit').submit();
#




