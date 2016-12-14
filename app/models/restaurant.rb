class Restaurant < ApplicationRecord

	has_many :restaurant_food_ships
    has_many :foods, :through => :restaurant_food_ships

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates

	has_many :foods
end
