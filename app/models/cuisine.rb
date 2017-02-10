class Cuisine < ApplicationRecord

	has_many :restaurant_cuisine_ships
	has_many :restaurants, :through => :restaurant_cuisine_ships

	has_many :food_cuisine_ships
	has_many :foods, :through => :food_cuisine_ships

end
