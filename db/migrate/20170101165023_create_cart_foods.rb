class CreateCartFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_foods do |t|
    	t.integer	:cart_id, :index => true
    	t.integer	:food_id, :index => true
    	t.float		:quantity
    	t.decimal :price, precision: 10, scale: 2
    	t.decimal :sub_total, precision: 10, scale: 2
      t.timestamps
    end
  end
end
