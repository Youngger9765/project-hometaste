class Add4ScoreToFoodComments < ActiveRecord::Migration[5.0]
  def change
  	add_column :food_comments, :taste_score, :float
  	add_column :food_comments, :value_score, :float
  	add_column :food_comments, :on_time_score, :float
  	rename_column :food_comments, :score, :summary_score
  end
end
