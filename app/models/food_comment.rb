class FoodComment < ApplicationRecord

	belongs_to :food
	belongs_to :user
	belongs_to :restaurant

	# validates :user_id, presence: true
	# validates :food_id, presence: true
	# validates :restaurant_id, presence: true
	# validates :taste_score, presence: true
	# validates :value_score, presence: true
	# validates :on_time_score, presence: true
	# validates :comment, presence: true


	def get_summary_score
		(self.taste_score + self.value_score + self.on_time_score)/3
	end


end
