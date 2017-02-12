class AddContactInfoToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :mobile_number, :string
  	add_column :orders, :email, :string
  	add_column :orders, :billing_address, :string
  	add_column :orders, :billing_city, :string
  	add_column :orders, :billing_state, :string
  	add_column :orders, :billing_zip_code, :string
  end
end
