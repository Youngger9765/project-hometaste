class Order < ApplicationRecord

	belongs_to :restaurant
	belongs_to :user
	belongs_to :bulk_buy

	has_many :order_food_ships
	has_many :foods, :through => :order_food_ships

	has_many :user_big_bun_ships
	has_many :big_buns, :through => :user_big_bun_ships

	def year_filter
	end

	def month_filter
	end

	def week_filter
	end

	def update_order_price
		update( amount: calc_amount )
		update( subtotal: calc_subtotal )
	end

	def calc_amount
		calc_subtotal + calc_tax
	end

	def calc_subtotal
		order_food_ships.pluck(:amount).reduce(:+).to_i
	end

	def calc_tax
		(calc_subtotal * ( restaurant.tax / 100 )).round(2)
	end

	# def calc_delivery
	# 	restaurant.delivery.cost || 0
	# end

end
