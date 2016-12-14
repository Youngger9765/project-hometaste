class CreateOrderFoodShips < ActiveRecord::Migration[5.0]
  def change
    create_table :order_food_ships do |t|
    	t.integer :order_id
    	t.integer	:food_id
    	t.decimal :quantity
    	t.decimal	:amount
      t.timestamps
    end
  end
end
