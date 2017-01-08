class RenameScheduleTimeToOrders < ActiveRecord::Migration[5.0]
  def change
  	rename_column :orders, :scheduled_time, :pick_up_datetime
  end
end
