class BigBunPhoto < ApplicationRecord

	belongs_to :big_bun

	has_attached_file :photo, styles: { medium: "300x300#", thumb: "100x100#" },
										default_url: ->(attachment) { ActionController::Base.helpers.asset_path('tmp/BB_DHD.png') }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
