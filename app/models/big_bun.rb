class BigBun < ApplicationRecord

	belongs_to :restaurant

	has_one :big_bun_photo

	accepts_nested_attributes_for :big_bun_photo,
    :allow_destroy => true,
    :reject_if => :all_blank
end
