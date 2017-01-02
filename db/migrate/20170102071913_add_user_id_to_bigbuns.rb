class AddUserIdToBigbuns < ActiveRecord::Migration[5.0]
  def change
  	add_column :big_buns, :user_id, :integer, :index => true
  	add_column :big_buns, :usage, :string
  	add_column :big_buns, :is_used, :boolean, :default => false
  end
end
