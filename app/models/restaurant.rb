class Restaurant < ApplicationRecord

	# has_many :restaurant_food_ships
	# has_many :foods, :through => :restaurant_food_ships
    has_many :foods
    has_many :orders
    has_many :restaurant_comments
    has_one  :delivery
    has_many :bulk_buys
    has_many :big_buns

	belongs_to :chef

    accepts_nested_attributes_for :delivery,
        :allow_destroy => true,
      :reject_if => :all_blank

    accepts_nested_attributes_for :bulk_buys,
        :allow_destroy => true,
      :reject_if => :all_blank

	geocoded_by :address
	after_validation :geocode # auto-fetch coordinates
end
