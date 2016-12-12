class Restaurant < ApplicationRecord

    has_many :foods
    has_many :orders

    belongs_to :user

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates
end
