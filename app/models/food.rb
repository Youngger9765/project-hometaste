class Food < ApplicationRecord

  belongs_to :restaurant

  has_many :order_food_ships
  has_many :orders, :through => :order_food_ships

  has_many :food_comments

  def average_score
    food_comments.pluck(:score).reduce(:+) / food_comments.all.size
  end

  def self.filter( price , features , distance , lat_long, sort , cuisine , ids = self.ids )
    where(id:ids).joins(:restaurant)
        .filter_price(price)
        .filter_features(features)
        .filter_distance(distance,lat_long)
        .filter_sort(sort)
        .filter_cuisine(cuisine)
  end

  def self.filter_price( _case , ordering = 'desc')
    foods = case _case[0]
            when '$'    ; where('price < ?',10)
            when '$$'   ; where('price >= ? and price < ?',11,30)
            when '$$$'  ; where('price >= ? and price < ?',31,60)
            when '$$$$' ; where('price > ? ',60)
            end
    foods.order("price #{ordering}")
  end

  def self.filter_features( _case )
    foods = self
    foods = foods.where(:is_public => true) if _case.include?("Today's Meal")
    foods = foods.where('restaurants.id = ?',Delivery.ids) if _case.include?('Delivery')
    foods = foods.where('restaurants.id = ?',BulkBuy.ids) if _case.include?('Bulk Buy')
    if _case.include?('Offer BigBun')
      restaurant_ids = BigBun.where(:is_public => true).pluck(:restaurant_id).uniq
      foods = foods.where('restaurants.id = ?',restaurant_ids)
    end
    foods
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
    when 'Most Reviewed'    ; joins(:food_comments).order('comment_counts desc')
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
      ids = FoodCuisineShip.where(cuisine_id:cuisine_ids).pluck(:food_id).uniq & self.ids
      where(id: ids)
    end
  end
end
