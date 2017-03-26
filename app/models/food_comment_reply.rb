class FoodCommentReply < ApplicationRecord
	belongs_to :food_comment
	belongs_to :user
end
