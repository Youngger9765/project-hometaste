class RenamePickUpTimeToOrders < ActiveRecord::Migration[5.0]
  def change
  	rename_column :orders, :pick_up_datetime, :pick_up_time
  end
end
