class AddTaxTipToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :tax, :float, :default => 0
  	add_column :restaurants, :tip, :float, :default => 0
  end
end
