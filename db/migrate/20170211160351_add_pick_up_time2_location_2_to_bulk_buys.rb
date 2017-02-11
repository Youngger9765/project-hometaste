class AddPickUpTime2Location2ToBulkBuys < ActiveRecord::Migration[5.0]
  def change
  	rename_column :bulk_buys, :pick_up_time, :pick_up_time_1
  	rename_column :bulk_buys, :location, :location_1

  	add_column :bulk_buys, :pick_up_time_2, :time
  	add_column :bulk_buys, :location_2, :string
  end
end
