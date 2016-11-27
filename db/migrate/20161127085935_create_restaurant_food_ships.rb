class CreateRestaurantFoodShips < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurant_food_ships do |t|
      t.integer :restaurant_id
      t.integer :food_id

      t.timestamps
    end
  end
end
