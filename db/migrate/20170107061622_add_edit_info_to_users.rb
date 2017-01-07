class AddEditInfoToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :last_name, :string
  	add_column :users, :state, :string
  	add_column :users, :city, :string
  end
end
