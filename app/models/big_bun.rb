class BigBun < ApplicationRecord

  before_create :set_code

  validates :start_datetime, :presence => true
  validates :stop_datetime, :presence => true

  belongs_to :restaurant
  has_one :big_bun_photo

  has_many :user_big_bun_ships
  has_many :users, :through => :user_big_bun_ships

  accepts_nested_attributes_for :big_bun_photo,
                                :allow_destroy => true,
                                :reject_if => :all_blank



  def self.available_bigbun
    bigbun = where( 'start_datetime <= ? and stop_datetime > ?',Time.current,Time.current ).first
    if bigbun
      prepare_time = bigbun.prepare_time.to_time.to_s(:time)
      hour = prepare_time[0..1].to_i
      min = prepare_time[3..4].to_i
      (bigbun.start_datetime + hour.hour + min.minute) < Time.current ? bigbun : 'preparing'
    else
      false
    end
  end

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
