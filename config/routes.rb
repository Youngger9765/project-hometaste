Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "main#index"

  get "main/index" => "main#index"
  get "admin" => "admin/users#index"

  namespace :admin do
  	resources :main
  	resources :users
  	resources :restaurants
  end

  resources :chefs
  resources :restaurants
  resources :foods

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
  	get "/getDishesByFilter" => "mains#getDishesByFilter"
  	get "/getRestaurantsByMap" => "restaurants#getRestaurantsByMap"
  end


end
