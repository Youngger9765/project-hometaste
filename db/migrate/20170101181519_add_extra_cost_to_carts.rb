class AddExtraCostToCarts < ActiveRecord::Migration[5.0]
  def change
  	add_column :carts, :delivery_fee, :float
  	add_column :carts, :tax, :float
  	add_column :carts, :tip, :float
  	add_column :carts, :total_amount, :decimal, precision: 10, scale: 2
  end
end
