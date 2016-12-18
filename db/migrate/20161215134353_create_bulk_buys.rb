class CreateBulkBuys < ActiveRecord::Migration[5.0]
  def change
    create_table :bulk_buys do |t|
    	t.integer			:restaurant_id,      null: false
    	t.float				:min_order
    	t.time		    :cut_off_time
    	t.string			:location
    	t.time 				:pick_up_time
      t.timestamps
    end
    add_index  :bulk_buys, :restaurant_id
  end
end
