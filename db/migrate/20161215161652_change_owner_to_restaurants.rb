class ChangeOwnerToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	rename_column :restaurants, :user_id, :chef_id
  end
end
