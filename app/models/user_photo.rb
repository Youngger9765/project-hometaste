class UserPhoto < ApplicationRecord

	belongs_to :user

	has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" },
										default_url: ->(attachment) { ActionController::Base.helpers.asset_path('tmp/profile_pic.png') }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
