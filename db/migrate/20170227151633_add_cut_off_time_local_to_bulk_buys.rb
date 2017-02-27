class AddCutOffTimeLocalToBulkBuys < ActiveRecord::Migration[5.0]
  def change
  	add_column :bulk_buys, :cut_off_time_local, :time
  end
end
