class ApiV1::MainsController < ApiController
  before_action :get_foods

  def getDishesByFilter
    @hash = Gmaps4rails.build_markers(@foods) do |food, marker|
      marker.lat food.restaurant.latitude
      marker.lng food.restaurant.longitude
      marker.infowindow food.restaurant.address
      marker.json({ id: food.restaurant.id,
                    close_url: "#{ ActionController::Base.helpers.image_path 'close.png'}",
                    html: gmap_html(food,food.average_score) })
    end
    render json: { gmap_hash: @hash, qty: @hash.size }, status: 200
  end

  private

  def gmap_html(food,rating)
    cuisines_group = []
    photo_group = []
    photos = food.food_photos
    photos.each_with_index do |photo,i|
      photo_group << "<div class='group'>
          						<input type='radio' name='test' id='#{i}' value='#{i}' #{'checked' if i ==0 }>
          						<label for='#{i-1 < 0 ? photos.size - 1 : i-1}' class='previous'></label>
          						<label for='#{i+1 > photos.size - 1 ? 0 : i+1}' class='next'></label>
          						<div class='content'>
          							<img style='background-image:url(#{photo.photo})'>
          						</div>
          					</div>"
    end

    food.cuisines.first(3).each do |cuisine|
      cuisines_group << "<span><a>#{ cuisine.name }</a></span>"
    end

    html = "<div class='ui fluid card'>
          	<div class='image'>
          		<div class='css_carousel'>
          			<div class='wrap'>
          				<div class='wrap2'>
          				#{photo_group.join('')}
          				</div>
          			</div>
          		</div>
          	</div>
          	<div class='content'>
          		<p class='description'><a href='/restaurants/#{ food.restaurant.id }'>#{ food.restaurant.name }</a></p>
          		<hr>
          		<div class='address_detail'>
          			<p>#{food.restaurant.address}</p>
          			<hr>
          		</div>
          		<p class='header'><a href='/foods/#{ food.id }'>#{ food.name }</a></p>
          		<p class='description' href='#'>$#{ food.price}/ Half食物</p>
          		<div class='meta hidden-xs'>
          			#{ cuisines_group.join('') }
          		</div>
          		<div class='show_rated_#{ rating.to_s.gsub('.','_') }'></div>
          	</div>
          </div>"
    return html
  end

  def get_foods
    @foods = Food.includes(:restaurant).find(params[:ids] || [])
  end
end
