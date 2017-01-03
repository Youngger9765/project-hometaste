class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
    	t.integer	:user_id, :index => true
    	t.integer	:restaurant_id, :index => true
    	t.decimal :sub_total, precision: 10, scale: 2
      t.timestamps
    end
  end
end
