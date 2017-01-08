class AddDeliveryFeeToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :delivery_fee, :float
  end
end
