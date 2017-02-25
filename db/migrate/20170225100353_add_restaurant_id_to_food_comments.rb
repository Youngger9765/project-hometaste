class AddRestaurantIdToFoodComments < ActiveRecord::Migration[5.0]
  def change
  	add_column :food_comments, :restaurant_id, :integer, :index => true
  end
end
