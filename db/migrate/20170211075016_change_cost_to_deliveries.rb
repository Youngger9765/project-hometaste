class ChangeCostToDeliveries < ActiveRecord::Migration[5.0]
  def change
  	change_column :deliveries, :cost, :decimal, :default => 0
  end
end
