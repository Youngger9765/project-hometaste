class ChangeQuantityCartBigbuns < ActiveRecord::Migration[5.0]
  def change
  	rename_column :cart_bigbuns, :quatity, :quantity
  end
end
