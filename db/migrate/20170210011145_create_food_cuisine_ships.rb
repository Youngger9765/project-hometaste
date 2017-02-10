class CreateFoodCuisineShips < ActiveRecord::Migration[5.0]
  def change
    create_table :food_cuisine_ships do |t|
    	t.integer :food_id, :index => true
      t.integer :cuisine_id, :index => true
      t.timestamps
    end
  end
end
