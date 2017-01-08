class RemoveUserIdToBigBuns < ActiveRecord::Migration[5.0]
  def change
  	remove_column :big_buns, :user_id
  	remove_column :big_buns, :usage
  	remove_column :big_buns, :is_used
  end
end
