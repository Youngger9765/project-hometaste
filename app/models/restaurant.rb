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

  def average_foods_price
    foods.pluck(:price).reduce(:+) / foods.size
  end

  def self.collect_food_ids
    all.collect {|x| x.foods.ids }.flatten!
  end

  def self.get_popular_foods
    Food.where( id: collect_food_ids ).joins( :food_comments ).order( 'food_comments.score desc' )
  end

  def self.new_in_foods
    Food.where( id: collect_food_ids ).where('foods.updated_at > ?', Time.current - 7.days )
  end

  def self.get_around_restaurants( km = 2, *coordinate )
    restaurant_ids = []
    lat, long = coordinate
    self.all.each {|restaurant| restaurant_ids << restaurant.id if restaurant.distance_to([lat,long],:km) < km }
    where(id: restaurant_ids)
  end

  def self.filter( price , features , distance , latlong , sort , cuisine , ids = self.ids )
    where(id:ids).filter_features(features).filter_price(price).filter_distance(distance,latlong).filter_sort(sort).filter_cuisine(cuisine)
  end

  def self.filter_price( _case )
    case _case
    when '$'    ; where('average_foods_price < ?' ,10)
    when '$$'   ; where('average_foods_price >= ? and average_foods_price < ?' ,11,30)
    when '$$$'  ; where('average_foods_price >= ? and average_foods_price < ?' ,31,60)
    when '$$$$' ; where('average_foods_price > ?' ,60)
    end
  end

  def self.filter_features( _case )
    ids = all.ids
    ids = ids & all.map {|x| x.id if x.foods.where(:is_public => true) } if _case.include?("Today's Meal")
    ids = ids & Delivery.pluck(:restaurant_id) if _case.include?('Delivery')
    ids = ids & BulkBuy.pluck(:restaurant_id) if _case.include?('Bulk Buy')
    ids = ids & BigBun.where(:is_public => true).pluck(:restaurant_id).uniq! if _case.include?('Offer Big')
    where(id:ids)
  end

  def self.filter_distance( _case , coordinate )
    lat, long = coordinate
    km = case _case[0]
         when 'Driving-5min' ; 2
         when 'Biking-5min'  ; 1
         when 'Walking-1min' ; 0.1
         else                ; _case.to_i * 0.1
         end
    restaurant_ids = Restaurant.get_around_restaurants( km , lat , long ).ids
    where(restaurant_id:restaurant_ids)
  end

  def self.filter_sort( _case )
    case _case[0]
    when 'BestMatch'        ; self
    when 'Highest Rated'    ; order('food_comments.average_score desc')
    when 'Most Reviewed'    ; joins(:food_comments).order('food_comments.size desc')
    when 'New'              ; order('updated_at desc')
    end
  end

  def self.filter_cuisine( _case )
    if _case.include?('Any Cuisine')
      self
    else
      _cases = _case.uniq
      _cases = _case.map {|x| "%#{ x.to_s.split(' ')[0].to_s.gsub(/[^a-zA-Z0-9\-]/,'') }%" }
      cuisine_ids = _cases.map {|x|  Cuisine.where('name like ?',x).ids}.flatten!
      ids = RestaurantCuisineShip.where(cuisine_id:cuisine_ids).pluck(:restaurant_id).uniq
      where(id: ids & self.ids )
    end
  end

end
