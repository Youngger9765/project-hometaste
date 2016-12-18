class RemoveRestaurantFoodShip < ActiveRecord::Migration[5.0]
  def change
  	drop_table :restaurant_food_ships
  end
end
