class ApiV1::RestaurantsController < ApiController

	def getRestaurantsByMap
		coordinate
	end

	private
	def coordinate
		coordinate = {}
		north_east = params[:north_east].match(/(\d*\.\d*), (\d*\.\d*)/)
		south_west = params[:south_west].match(/(\d*\.\d*), (\d*\.\d*)/)
		coordinate[:north],coordinate[:east] = north_east[1],north_east[2]
		coordinate[:south],coordinate[:west] = south_west[1],south_west[2]
		coordinate
	end
end
