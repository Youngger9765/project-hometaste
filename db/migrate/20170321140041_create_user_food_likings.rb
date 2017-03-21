class CreateUserFoodLikings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_food_likings do |t|
    	t.integer :user_id
    	t.integer :food_id
      t.timestamps
    end
  end
end
