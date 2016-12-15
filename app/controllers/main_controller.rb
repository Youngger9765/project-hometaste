class MainController < ApplicationController

	def index
		@user = User.new
		@foods = Food.all.includes(:restaurant).sample(100)

		# restaurant's feature
		today_meal_restaurant_ids = Food.all.where(:is_public => true).pluck(:restaurant_id).uniq
		@today_meal = Restaurant.find(today_meal_restaurant_ids)

		bulk_buy_restaurant_ids = BulkBuy.all.pluck(:restaurant_id).uniq
		@bulk_buy = Restaurant.find(bulk_buy_restaurant_ids)

		delivery_restaurant_ids = Delivery.all.pluck(:restaurant_id).uniq
		@delivery = Restaurant.find(delivery_restaurant_ids)

		raise

		@offer_big_bun
	end
end
