class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
    	t.integer			:restaurant_id,      null: false
    	t.float				:min_order
    	t.string			:area
    	t.float				:distance
    	t.decimal			:cost
    	t.time 				:order_hours
      t.timestamps
    end
    add_index  :deliveries, :restaurant_id
  end
end
