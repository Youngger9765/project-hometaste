class Restaurant < ApplicationRecord

	# has_many :restaurant_food_ships
	# has_many :foods, :through => :restaurant_food_ships
    has_many :foods
    has_many :orders
    has_many :restaurant_comments
    has_one :delivery
    has_many :bulk_buys

	belongs_to :user

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates
end
