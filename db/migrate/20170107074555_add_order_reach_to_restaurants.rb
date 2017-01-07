class AddOrderReachToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :order_reach, :float
  end
end
