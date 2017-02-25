class ApiV1::RestaurantsController < ApiController

	def getRestaurantsByMap
		coordinate
		@restaurants = Restaurant.where( latitude: coordinate[:south]..coordinate[:north],
																																			longitude: coordinate[:west]..coordinate[:east] ).limit(params[:qty]).sample(9)
		@hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
			marker.lat restaurant.latitude
			marker.lng restaurant.longitude
			marker.infowindow restaurant.address
			marker.json({ id: restaurant.id,
																	close_url: "#{ ActionController::Base.helpers.image_path 'close.png'}",
																	html: gmap_html(restaurant,0.5) })
		end
		render json: { gmap_hash: @hash, qty: @hash.size }, status: 200
	end

	private

	def coordinate
		coordinate = {}
		coordinate[:north] = params[:north].to_f
		coordinate[:east] = params[:east].to_f
		coordinate[:south] = params[:south].to_f
		coordinate[:west] = params[:west].to_f
		coordinate
	end

	def gmap_html(restaurant,rating)
		group = []
		imgs = %w{http://i.stack.imgur.com/R5yzx.jpg http://i.stack.imgur.com/k0Hsd.jpg http://i.stack.imgur.com/Hhl9H.jpg http://i.stack.imgur.com/r1AyN.jpg http://i.stack.imgur.com/EHHsa.jpg}
		imgs.each_with_index do |img,i|
			group << "<div class='group'>
          						<input type='radio' name='test' id='#{i}' value='#{i}' #{'checked' if i ==0 }>
          						<label for='#{i-1 < 0 ? imgs.size - 1 : i-1}' class='previous'></label>
          						<label for='#{i+1 > imgs.size - 1 ? 0 : i+1}' class='next'></label>
          						<div class='content'>
          							<img style='background-image:url(#{img})'>
          						</div>
          					</div>"
		end

		html = "<div class='gmap_cards'>
		<div class='ui fluid card'>
          	<div class='image'>
          		<div class='css_carousel'>
          			<div class='wrap'>
          				<div class='wrap2'>
          				#{group.join('')}
          				</div>
          			</div>
          		</div>
          	</div>
          	<div class='content'>
              <h4><p class='description'><a href='/'>#{ restaurant.name }</a></p></h4>
									<hr>
							  <div class='flex_center_start location'>
											<div class='flex_center'>
												<p>#{restaurant.address}</p>
											</div>
                  </div>
								<hr>
                  <div class='rating_wrapping'>
                    <div class='show_rated_#{ rating.to_s.gsub!('.','_') }'></div>
                    <span name='reivews'>200 Reviews</span>
                  </div>
                  <div class='num_counts'>
                    #{ActionController::Base.helpers.image_tag 'heart_icon.png'}
                    <span>102 Likes</span>
                    #{ActionController::Base.helpers.image_tag 'plate_icon.png'}
                    <span>238 Orders</span>
                  </div>
                  <div class='meta hidden-xs'>
                    <span><a href'>Vegan</a></span><span><a href'>Soup</a></span><span><a href'>Pumkim</a></span><span><a href'>Autum</a></span>
                  </div>

                </div>
          </div>
			</div>"
		return html
	end
end
