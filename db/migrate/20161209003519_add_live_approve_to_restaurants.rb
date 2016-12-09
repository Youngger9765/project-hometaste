class AddLiveApproveToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :is_live, :boolean, default: true
  	add_column :restaurants, :is_approved, :boolean, default: false

  	add_index :restaurants, :is_live
  	add_index :restaurants, :is_approved
  end
end
