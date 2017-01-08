class RemoveTipToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	remove_column :restaurants, :tip
  end
end
