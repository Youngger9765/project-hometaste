$(document).ready ->

  get_cart_list=() ->
    $.parseJSON( $.cookie('cart_list') )

  deal_food_list=(_this) ->
    _data = $(_this).closest('.food_data_info')
    food_id = _data.data('food-id')
    food_price = +_data.data('food-price').replace('$','')
    restaurant_id = _data.data('restaurant-id')
    qty = +$(_this).siblings('#txtNum').val()

    info_object = get_cart_list() || {}

    if qty > 0
      info_object["restaurant_#{restaurant_id}"] =
        "food_#{food_id}":
          qty:qty,
          price:food_price
    else if qty == 0
      if info_object.hasOwnProperty("restaurant_#{restaurant_id}")
        if info_object["restaurant_#{restaurant_id}"].hasOwnProperty("food_#{food_id}")
          delete info_object["restaurant_#{restaurant_id}"]["food_#{food_id}"]
          if Object.keys(info_object["restaurant_#{restaurant_id}"]).length == 0
            delete info_object["restaurant_#{restaurant_id}"]

    $.cookie('cart_list', JSON.stringify(info_object) )
#    當次food object
    return restaurant_id:restaurant_id,food_id:food_id,food_price:food_price,qty:qty,info_object:info_object

  deal_bigbun_list=(_this) ->
    bigbun_id = $(this).data('bigbun-id')
    restaurant_id = $(this).data('restaurant-id')

    info_object = get_cart_list() || {}
    info_object["restaurant_#{restaurant_id}"] =
      bigbun_id:bigbun_id
  console.log(info_object);
#    food qty up or down
  $(document).on 'click', ".product_spineer_button" , ->
    food_info = deal_food_list(this)
#    不計算加減，每點一次就撈一次現值

#    bigbun add
  $(document).on 'click', ".bigbun.after_prepartion" , ->
    bigbun_info = deal_bigbin_list(this)
    info_object = get_cart_list() || {}
