class Chef < ApplicationRecord

	belongs_to :user

	has_one :restaurant
end
