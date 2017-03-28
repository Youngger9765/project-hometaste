class ChangeUserIdToChefIdInReplies < ActiveRecord::Migration[5.0]
  def change
  	rename_column :food_comment_replies, :user_id, :chef_id
  end
end
