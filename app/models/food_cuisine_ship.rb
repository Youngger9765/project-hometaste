class FoodCuisineShip < ApplicationRecord
	belongs_to :food
	belongs_to :cuisine
end
