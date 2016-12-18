class CreateRestaurantCuisineShips < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurant_cuisine_ships do |t|
    	t.integer :restaurant_id, :index => true
      t.integer :cuisine_id, :index => true
      t.timestamps
    end
  end
end
