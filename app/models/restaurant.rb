class Restaurant < ApplicationRecord

  has_many :foods
  has_many :orders
  has_many :restaurant_comments
  has_one  :delivery
  has_many :bulk_buys
  has_many :big_buns
  has_many :restaurant_dish_photos

  belongs_to :chef

  has_many :restaurant_cuisine_ships
  has_many :cuisines, :through => :restaurant_cuisine_ships

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
  has_attached_file :certificated_img, styles: { medium: "300x300#", thumb: "100x100#" },
                    default_url: ->(attachment) { ActionController::Base.helpers.asset_path('tmp/kitchen.png') }
  validates_attachment_content_type :certificated_img, content_type: /\Aimage\/.*\Z/

  # main_photo
  has_attached_file :main_photo, styles: { medium: "300x300#", thumb: "100x100#" },
                    default_url: ->(attachment) { ActionController::Base.helpers.asset_path('tmp/kitchen.png') }
  validates_attachment_content_type :main_photo, content_type: /\Aimage\/.*\Z/

  def average_foods_price
    foods.average(:price) || 0
  end

  def chef_name
    chef.first_name.capitalize + chef.last_name.capitalize
  end

  def get_available_bigbun
    big_buns.available_bigbun
  end

  def get_near_pickup_time
    bulk_buys.select { |x| x.pick_up_time if x.pick_up_time > Time.current }.first
  end

  def food_score
    score = food_avg_score.round(1)
    score = if score.to_s[-1].to_i >= 5
              (score.to_s[0].to_i + 1).to_i
            elsif score.to_s[-1].to_i > 0
              score.to_i + 0.5
            else
              score.to_i
            end
    score.to_s.gsub('.', '_')
  end

  def self.collect_food_ids
    all.collect {|x| x.foods.ids }.flatten
  end

  def self.get_popular_foods(num = 100)
    Food.where(id: collect_food_ids).joins(:food_comments).order('food_comments.score desc').limit(num)
  end

  def self.new_in_foods(num = 100)
    Food.where(id: collect_food_ids).where('foods.updated_at > ?', Time.current - 7.days ).limit(num)
  end

  def delivery_time(to = Time.current.end_of_day, step = 15.minutes)
    cut_off_time = bulk_buys.reduce([]) { |all,ele| all << ele.cut_off_time if ele.cut_off_time > Time.current }
    cut_off_time = if cut_off_time.present?
                     cut_off_time[0].at_end_of_hour + 1.second
                   else
                     [Time.current.at_end_of_hour + 1.second]
                   end
    cut_off_time.tap { |array| array << array.last + step while array.last < to }
    cut_off_time.map { |x| x.strftime('%R') }
  end

  def self.get_around_restaurants(km = 2, *coordinate)
    restaurant_ids = []
    lat, long = coordinate
    all.each do |restaurant|
      if restaurant.distance_to([lat, long], :km) && restaurant.distance_to([lat, long], :km) < km
        restaurant_ids << restaurant.id
      end
    end
    where(id: restaurant_ids)
  end

  def self.filter(params, lat_long, ids = self.ids)
    sort = params['Sort By']
    distance = params['Distance']
    price = params['Price']
    cuisine = params['Cuisine']
    features = params['Features']

    where(id: ids).filter_distance(distance, lat_long)
        .filter_features(features)
        .filter_cuisine(cuisine)
        .filter_price(price)
        .filter_sort(sort)
  end

  def self.filter_price(_case)
    case _case[0]
    when '$'    then min, max = 0, 10
    when '$$'   then min, max = 11, 30
    when '$$$'  then min, max = 31, 60
    when '$$$$' then min, max = 61, 10000000
    end
    ids = all.collect do |x|
      price = x.average_foods_price
      x.id if price && (price > min && price <= max)
    end
    where(id: ids.compact)
  end

  def self.filter_features(_case)
    ids = all.ids
    ids &= all.map {|x| x.id if x.foods.where(is_public: true) } if _case.include?("Today's Meal")
    ids &= Delivery.pluck(:restaurant_id) if _case.include?('Delivery')
    ids &= BulkBuy.pluck(:restaurant_id) if _case.include?('Bulk Buy')
    ids &= BigBun.where(is_public: true).pluck(:restaurant_id).uniq if _case.include?('Offer Big')
    where(id:ids)
  end

  def self.filter_distance(_case, coordinate)
    lat, long = coordinate
    km = case _case[0]
         when 'Driving-5min' then 2
         when 'Biking-5min'  then 1
         when 'Walking-1min' then 0.1
         else
           _case[0].to_i * 0.1
         end
    restaurant_ids = Restaurant.get_around_restaurants( km , lat , long ).ids
    where(id:restaurant_ids)
  end

  def self.filter_sort(_case)
    case _case[0]
    when 'BestMatch'        then self.all
    when 'Highest Rated'    then order('food_avg_score desc')
    when 'Most Reviewed'    then order('food_comments_count desc')
    when 'New'              then order('updated_at desc')
    end
  end

  def self.filter_cuisine(_case)
    if _case.include?('Any Cuisine')
      self.all
    else
      _cases = _case.uniq
      _cases = _case.map { |x| "%#{ x.to_s.split(' ')[0].to_s.gsub(/[^a-zA-Z0-9\-]/,'') }%" }
      cuisine_ids = _cases.map { |x| Cuisine.where('name like ?', x).ids}.flatten
      ids = RestaurantCuisineShip.where(cuisine_id: cuisine_ids).pluck(:restaurant_id).uniq
      where(id: ids & self.ids)
    end
  end

  def get_food_avg_score
    food_ids = foods.pluck(:id)
    if FoodComment.find_by(food_id: food_ids)
      FoodComment.where(food_id: food_ids).average(:score)
    else
      0
    end
  end

end
