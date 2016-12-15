class Restaurant < ApplicationRecord

	# has_many :restaurant_food_ships
	# has_many :foods, :through => :restaurant_food_ships
    has_many :foods
    has_many :orders
    has_many :restaurant_comments

	belongs_to :user

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates
end
