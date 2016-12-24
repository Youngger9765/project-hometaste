class AddFoodCommentsCountToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :food_comments_count, :integer, :default => 0
  end
end
