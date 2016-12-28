module ChefsHelper
	def setup_chef(chef)
	  chef.build_restaurant unless chef.restaurant
	  chef.build_user unless chef.user
	  chef.user.build_user_photo unless chef.user.user_photo
	  chef.restaurant.build_delivery unless chef.restaurant.delivery
	  if !chef.id
	  	2.times{chef.restaurant.bulk_buys.build}
		  3.times{chef.restaurant.restaurant_cuisine_ships.build}
		  3.times{chef.restaurant.restaurant_dish_photos.build}
		else
			bulk_buys_size = chef.restaurant.bulk_buys.size
			restaurant_cuisine_ships_size = chef.restaurant.restaurant_cuisine_ships.size
			restaurant_dish_photos_size = chef.restaurant.restaurant_dish_photos.size

			bulk_buys_request = 2-bulk_buys_size
			restaurant_cuisine_ships_request = 3-restaurant_cuisine_ships_size
			restaurant_dish_photos_request = 3-restaurant_dish_photos_size

			bulk_buys_request.times{chef.restaurant.bulk_buys.build}
		  restaurant_cuisine_ships_request.times{chef.restaurant.restaurant_cuisine_ships.build}
		  restaurant_dish_photos_request.times{chef.restaurant.restaurant_dish_photos.build}
	  end
	  chef
	end
end
