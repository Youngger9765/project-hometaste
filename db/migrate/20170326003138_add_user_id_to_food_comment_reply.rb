class AddUserIdToFoodCommentReply < ActiveRecord::Migration[5.0]
  def change
  	add_column :food_comment_replies, :user_id, :integer, :index => true
  end
end
