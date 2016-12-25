module FoodsHelper
	def setup_food(food)
		if !food.id
			3.times{food.food_photos.build}

		else
			food_photos_size = food.food_photos.size
			food_photos_request = 3-food_photos_size
			food_photos_request.times{food.food_photos.build}
		end

	  food
	end
end
