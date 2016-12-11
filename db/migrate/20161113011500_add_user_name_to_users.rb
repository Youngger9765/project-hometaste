class AddUserNameToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :name, :string, null: false
  	add_column :users, :user_name, :string, null: false
  	add_column :users, :phone_number, :string, null: false
  end
end
