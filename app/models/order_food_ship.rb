class OrderFoodShip < ApplicationRecord
	belongs_to :food
	belongs_to :order
	after_create :calc_amount

	def calc_amount
		update( amount:food.price * quantity )
	end
end
