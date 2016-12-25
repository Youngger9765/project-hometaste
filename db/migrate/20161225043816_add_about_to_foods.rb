class AddAboutToFoods < ActiveRecord::Migration[5.0]
  def change
  	add_column :foods, :about, :text
  	add_column :foods, :ingredients, :text
  	add_column :foods, :unit, :float
  	add_column :foods, :unit_name, :string
  	add_column :foods, :max_order, :float
  	add_column :foods, :availability_date, :date
  end
end
