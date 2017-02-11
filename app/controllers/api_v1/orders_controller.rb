class ApiV1::OrdersController < ApplicationController

  def check_delivery_location
    @restaurant = Restaurant.find(params[:restaurant_id])
    lat, long = Geocoder.coordinates(params[:text])
    distance = @restaurant.distance_to([lat, long], :km)
    if @restaurant.delivery && distance < @restaurant.delivery.distance
      render json: { status: 'success', message: 'Your location is good to delivery!' }
    elsif @restaurant.delivery && distance > @restaurant.delivery.distance
      render json: { status: 'success', message: "Your location too far away, we couldn't offer service sorry #{distance}km!" }
    else
      render json: { status: 'success', message: "Plase enter right address or vaild address!" }
    end
  end
end
