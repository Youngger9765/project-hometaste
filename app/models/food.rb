class Food < ApplicationRecord
  # has_many :restaurant_food_ships
  # has_many :restaurants, :through => :restaurant_food_ships

  belongs_to :restaurant

  has_many :order_food_ships
  has_many :orders, :through => :order_food_ships

  has_many :food_comments

end
