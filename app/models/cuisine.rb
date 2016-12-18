class Cuisine < ApplicationRecord

	has_many :restaurant_cuisine_ships
	has_many :restaurants, :through => :restaurant_cuisine_ships

end
