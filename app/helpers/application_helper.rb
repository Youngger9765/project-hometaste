module ApplicationHelper
  def food_restaurant_info(food = 'default')
    if food == 'default'
      name = price = food_id = restaurant_id = tax = cost = distance = -1
    else
      name = food.name
      price = food.price
      food_id = food.id
      restaurant_id = food.restaurant.id
      tax = food.restaurant.tax
      if food.restaurant.delivery
        cost = food.restaurant.delivery.cost
        distance = food.restaurant.delivery.distance
      else
        cost = distance = -1
      end
    end
    "data-food-name=#{name} data-food-price=#{price} data-food-id=#{food_id}
    data-restaurant-id=#{restaurant_id} data-restaurant-tax=#{tax}
    data-restaurant-cost=#{cost} data-restaurant-distance=#{distance}"
  end

end
