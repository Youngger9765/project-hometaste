class CreateFoodCommentReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :food_comment_replies do |t|
    	t.integer :food_comment_id, :index => true
    	t.text 		:content
      t.timestamps
    end
  end
end
