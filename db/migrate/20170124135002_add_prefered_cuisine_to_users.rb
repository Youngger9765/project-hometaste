class AddPreferedCuisineToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users , :prefered_cuisine_ids, :text, array:true
  end
end
