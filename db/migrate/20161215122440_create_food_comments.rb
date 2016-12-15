class CreateFoodComments < ActiveRecord::Migration[5.0]
  def change
    create_table :food_comments do |t|
    	t.integer			:user_id,      null: false
    	t.integer 		:food_id,      null: false
    	t.text				:comment,      null: false
      t.float				:score
      t.boolean			:is_public,			null: false, default: true
      t.timestamps
    end
    add_index  :food_comments, :user_id
    add_index  :food_comments, :food_id
  end
end
