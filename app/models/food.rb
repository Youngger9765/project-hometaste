class Food < ApplicationRecord
  has_many :restaurant_food_ships
  has_many :restaurants, :through => :restaurant_food_ships
end
