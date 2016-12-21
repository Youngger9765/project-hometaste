module ChefsHelper
	def setup_chef(chef)
	  chef.build_restaurant unless chef.restaurant
	  chef.build_user unless chef.user
	  chef.restaurant.build_delivery unless chef.restaurant.delivery
	  2.times{chef.restaurant.bulk_buys.build}
	  3.times{chef.restaurant.restaurant_cuisine_ships.build}
	  3.times{chef.restaurant.restaurant_dish_photos.build}
	  chef
	end
end
