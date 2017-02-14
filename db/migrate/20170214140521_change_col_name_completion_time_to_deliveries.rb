class ChangeColNameCompletionTimeToDeliveries < ActiveRecord::Migration[5.0]
  def change
  	rename_column :deliveries, :order_hours, :completion_time
  end
end
