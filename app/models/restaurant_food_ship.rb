class RestaurantFoodShip < ApplicationRecord

	belongs_to :restaurant
    belongs_to :food
end
