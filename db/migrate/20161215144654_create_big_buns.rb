class CreateBigBuns < ActiveRecord::Migration[5.0]
  def change
    create_table :big_buns do |t|
    	t.integer			:restaurant_id,      	null: false
    	t.string			:name,								null: false
    	t.integer			:piece
    	t.datetime		:start_datetime
    	t.datetime 		:stop_datetime
      t.timestamps
    end
  end
end
