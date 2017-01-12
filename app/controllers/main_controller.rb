class MainController < ApplicationController

	def index
		approved_restaurant = Restaurant.where(:is_approved => true)
		@foods = Food.where(:restaurant_id => approved_restaurant.ids).includes(:restaurant).sample(100)

		# restaurant's feature
		today_meal_restaurant_ids = Food.where(:is_public => true).pluck(:restaurant_id).uniq
		@today_meal = approved_restaurant.where(id: today_meal_restaurant_ids)

		bulk_buy_restaurant_ids = BulkBuy.pluck(:restaurant_id).uniq
		@bulk_buy = approved_restaurant.where(id:bulk_buy_restaurant_ids)

		delivery_restaurant_ids = Delivery.pluck(:restaurant_id).uniq
		@delivery = approved_restaurant.where(id:delivery_restaurant_ids)

		big_bun_restaurant_ids = BigBun.where(:is_public => true).pluck(:restaurant_id).uniq
		@offer_big_bun = approved_restaurant.where(id:big_bun_restaurant_ids)
		@cuisines = Cuisine.all

		save_search_results_in_cookies
  end

	private

  def save_search_results_in_cookies
    ids = @foods.map{|x|x.id}
    cookies.signed[:search_results] = {value: {food: ids} }
  end

end
