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
    if bigbun && bigbun.availible_num > 0
      bigbun
    else
      false
    end
  end

  def is_preparing?
    prepare_time = self.prepare_time.to_time.to_s(:time)
    hour = prepare_time[0..1].to_i
    min = prepare_time[3..4].to_i
    (start_datetime + hour.hour + min.minute) > Time.current
  end

  def prepared?
    prepare_time = self.prepare_time.to_time.to_s(:time)
    hour = prepare_time[0..1].to_i
    min = prepare_time[3..4].to_i
    (start_datetime + hour.hour + min.minute) < Time.current
  end

  def availible_num
    total = self.unit
    ships = self.user_big_bun_ships
    # 如果是 self 取得，就算佔據
    self_num = ships.where(:usage => "self").size
    # 如果是分享的，要實際用掉才算用掉
    gift_used_num = ships.where(:usage => "gift", :is_used => 1).size
    availible_num = total - self_num - gift_used_num
    availible_num
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
