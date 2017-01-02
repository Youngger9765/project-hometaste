class ChangeBigbunsCode < ActiveRecord::Migration[5.0]
  def change
  	change_column :big_buns, :code, :string, :null => false, :unique => false
  end
end
