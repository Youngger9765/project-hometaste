class Food < ApplicationRecord

    belongs_to :restaurant

    has_many :order_food_ships
    has_many :orders, :through => :order_food_ships

end
