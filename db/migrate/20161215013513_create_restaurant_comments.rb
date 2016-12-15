class CreateRestaurantComments < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurant_comments do |t|
    	t.integer			:user_id
    	t.integer 		:restaurant_id
    	t.text				:comment
      t.float				:score
      t.boolean			:is_public,			null: false, default: true
      t.timestamps
    end
  end
end
