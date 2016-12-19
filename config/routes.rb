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

  resources :users
  resources :chefs
  resources :restaurants

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
    get "/search/filter" => "search#filter"
    get "/search/keyword" => "search#keyword"
  	get "/getDishesByFilter" => "mains#getDishesByFilter"
  	get "/getRestaurantsByMap" => "restaurants#getRestaurantsByMap"
  end


end
