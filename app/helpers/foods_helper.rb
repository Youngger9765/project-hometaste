module FoodsHelper
	def setup_food(food)
		if !food.id
			# new
			3.times{food.food_photos.build}
			3.times{food.food_cuisine_ships.build}

		else
			# edit
			food_photos_size = food.food_photos.size
			food_photos_request = 3-food_photos_size
			food_photos_request.times{food.food_photos.build}

			food_cuisine_ships_size = food.food_cuisine_ships.size
			food_cuisine_ships_request = 3-food_cuisine_ships_size
			food_cuisine_ships_request.times{food.food_cuisine_ships.build}
		end

		food
	end

	def food_main_photo(food)
		if food.food_photos.present?
			food.food_photos.first.try(:photo).to_s
		else
      ActionController::Base.helpers.asset_path('tmp/product.png')
		end
	end
end
