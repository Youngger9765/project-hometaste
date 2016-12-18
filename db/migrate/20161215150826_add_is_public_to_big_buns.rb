class AddIsPublicToBigBuns < ActiveRecord::Migration[5.0]
  def change
  	add_column :big_buns, :is_public, :boolean, default: false
  end
end
