class AddDetailToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :city, 	:string
  	add_column :restaurants, :state, 	:string
  	add_column :restaurants, :ZIP, 		:integer
  	add_column :restaurants, :tax_ID, 	:string
  	add_column :restaurants, :communication_method, 	:string

  	add_index :restaurants, :city
  	add_index :restaurants, :state
  	add_index :restaurants, :ZIP
  end
end
