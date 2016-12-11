class Restaurant < ApplicationRecord

    has_many :foods

    belongs_to :user

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates
end
