class UserBigBunShip < ApplicationRecord
	belongs_to :user
	belongs_to :big_bun
	belongs_to :order
end
