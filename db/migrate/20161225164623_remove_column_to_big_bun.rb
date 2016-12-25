class RemoveColumnToBigBun < ActiveRecord::Migration[5.0]
  def change
  	remove_column :big_buns, :name
  	remove_column :big_buns, :piece
  end
end
