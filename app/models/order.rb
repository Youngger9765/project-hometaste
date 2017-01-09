class Order < ApplicationRecord

	belongs_to :restaurant
	belongs_to :user

	has_many :order_food_ships
	has_many :foods, :through => :order_food_ships

	has_many :user_big_bun_ships
	has_many :big_buns, :through => :user_big_bun_ships
	after_create :calc_amount

	def year_filter
	end

	def month_filter
	end

	def week_filter
	end

	def calc_amount
		update( amount: order_food_ships.pluck(:amount).reduce(:+) )
	end

end
