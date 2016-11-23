class ApiV1::MainsController < ApiController

	def getDishesByFilter
		restaurants = Restaurant.all
		@hash = Gmaps4rails.build_markers(restaurants) do |restaurant, marker|
			marker.lat restaurant.latitude
			marker.lng restaurant.longitude
			marker.infowindow restaurant.address
			marker.json({ id: restaurant.id,
										close_url: "#{ ActionController::Base.helpers.image_path 'close.png'}",
										html: gmap_html(restaurant,0.5) })
		end
		render json: { gmap_hash: @hash }, status: 200
	end

	private

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

		html = "<div class='ui fluid card'>
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
          		<p class='description'><a href='/'>Mr.chans Kitchen</a></p>
          		<hr>
          		<div class='address_detail'>
          			<p>#{restaurant.address}</p>
          			<hr>
          		</div>
          		<p class='header'><a href='/'>Roasted Duck</a></p>
          		<p class='description' href='#'>$7.00/ Half</p>
          		<div class='meta hidden-xs'>
          			<span><a href'>Vegan</a></span><span><a href'>Soup</a></span><span><a href'>Pumkim</a></span><span><a href'>Autum</a></span>
          		</div>
          		<div class='show_rated_#{ rating.to_s.gsub!('.','_') }'></div>
          	</div>
          </div>"
		return html
	end
end
