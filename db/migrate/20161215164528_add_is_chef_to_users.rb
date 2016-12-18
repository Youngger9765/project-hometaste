class AddIsChefToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :is_chef, :boolean, default: false
  	add_index  :users, :is_chef
  end
end
