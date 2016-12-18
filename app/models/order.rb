class Order < ApplicationRecord

	belongs_to :restaurant
	belongs_to :user

	has_many :order_food_ships
	has_many :foods, :through => :order_food_ships
end
