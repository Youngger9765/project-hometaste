class Restaurant < ApplicationRecord

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates

	has_many :foods
end
