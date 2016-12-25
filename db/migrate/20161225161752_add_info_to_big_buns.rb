class AddInfoToBigBuns < ActiveRecord::Migration[5.0]
  def change
  	add_column :big_buns, :style, :string
  	add_column :big_buns, :unit, :integer
  end
end
