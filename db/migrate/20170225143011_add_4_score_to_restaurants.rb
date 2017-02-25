class Add4ScoreToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :food_avg_taste_score, :float, :default => 3
  	add_column :restaurants, :food_avg_value_score, :float, :default => 3
  	add_column :restaurants, :food_avg_on_time_score, :float, :default => 3
  	rename_column :restaurants, :food_avg_score, :food_avg_summary_score
  	change_column :restaurants, :food_avg_summary_score, :float, :default => 3
  end
end
