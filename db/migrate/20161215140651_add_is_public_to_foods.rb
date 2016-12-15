class AddIsPublicToFoods < ActiveRecord::Migration[5.0]
  def change
  	add_column :foods, :is_public, :boolean, default: false
  end
end
