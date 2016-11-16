Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "main#index"

  get "main/index" => "main#index"

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
  	get "/getDishesByFilter" => "mains#getDishesByFilter"
  	get "/getRestaurantsByMap" => "restaurants#getRestaurantsByMap"
	end


end
