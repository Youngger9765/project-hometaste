class Cart < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant
	has_many :cart_foods
	has_many :cart_bigbuns
end
