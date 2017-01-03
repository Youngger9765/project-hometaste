class AddPrepareTimeToBigBuns < ActiveRecord::Migration[5.0]
  def change
  	add_column :big_buns, :prepare_time, :time
  	add_column :big_buns, :code, :string, :null => false, :unique => true
  end
end
