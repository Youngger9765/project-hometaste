class BigBun < ApplicationRecord

	before_create :set_code

	validates :start_datetime, :presence => true
	validates :stop_datetime, :presence => true

	belongs_to :restaurant
  belongs_to :user
	has_one :big_bun_photo

  has_many :user_big_bun_ships

	accepts_nested_attributes_for :big_bun_photo,
    :allow_destroy => true,
    :reject_if => :all_blank




  private

  def set_code
    self.code = generate_code unless self.code
  end

  def generate_code
    loop do
      code = SecureRandom.hex(4)
      break code unless BigBun.where(code: code).exists?
    end
  end
end
