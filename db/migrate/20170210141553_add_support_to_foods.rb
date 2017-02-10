class AddSupportToFoods < ActiveRecord::Migration[5.0]
  def change
  	add_column :foods, :support_lunch, :boolean, :default => 0
  	add_column :foods, :support_dinner, :boolean, :default => 0
  end
end
