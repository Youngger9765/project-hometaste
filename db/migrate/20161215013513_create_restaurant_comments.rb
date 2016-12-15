class CreateRestaurantComments < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurant_comments do |t|
    	t.integer			:user_id,      null: false
    	t.integer 		:restaurant_id,      null: false
    	t.text				:comment,      null: false
      t.float				:score
      t.boolean			:is_public,			null: false, default: true
      t.timestamps
    end
    add_index  :restaurant_comments, :user_id
    add_index  :restaurant_comments, :restaurant_id
  end
end
