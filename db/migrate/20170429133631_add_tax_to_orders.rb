class AddTaxToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :tax, :float
  end
end
