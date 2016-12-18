class Restaurant < ApplicationRecord

  has_many :foods
  has_many :orders
  has_many :restaurant_comments
  has_one  :delivery
  has_many :bulk_buys
  has_many :big_buns
  has_many :restaurant_dish_photos, dependent: :destroy

  belongs_to :chef

  has_many :restaurant_cuisine_ships
  has_many :restaurants, :through => :restaurant_cuisine_ships

  accepts_nested_attributes_for :delivery,
    :allow_destroy => true,
    :reject_if => :all_blank

  accepts_nested_attributes_for :bulk_buys,
    :allow_destroy => true,
      :reject_if => :all_blank

  accepts_nested_attributes_for :restaurant_cuisine_ships,
    :allow_destroy => true,
      :reject_if => :all_blank

  accepts_nested_attributes_for :restaurant_dish_photos,
    :allow_destroy => true,
      :reject_if => :all_blank

  geocoded_by :address
  after_validation :geocode # auto-fetch coordinates

  # certificated imag
  has_attached_file :certificated_img, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :certificated_img, content_type: /\Aimage\/.*\Z/

  # main_photo
  has_attached_file :main_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :main_photo, content_type: /\Aimage\/.*\Z/

end
