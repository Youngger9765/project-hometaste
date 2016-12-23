class AddFoodsAvgScoreToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :food_avg_score, :float, :default => 0
  end
end
