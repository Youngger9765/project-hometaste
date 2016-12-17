class Chef < ApplicationRecord

	belongs_to :user
	has_one :restaurant

	accepts_nested_attributes_for :restaurant,
		:allow_destroy => true,
	  :reject_if => :all_blank

	accepts_nested_attributes_for :user,
		:allow_destroy => true,
	  :reject_if => :all_blank
end
