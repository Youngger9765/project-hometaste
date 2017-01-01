Rails.application.routes.draw do

  get 'transactions/new'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "main#index"

  get "main/index" => "main#index"
  get "admin" => "admin/users#index"

  namespace :admin do
    resources :main
    resources :orders do
      collection do
        get :today
      end
    end
  	resources :users
  	resources :restaurants
  end

  resources :users

  resources :chefs do
    resources :foods
    resources :big_buns
    member do
      get :review
      get :approve
      get :add_dish
      post :save_dish
      get :add_big_bun
      get :menu
    end
  end

  resources :foods

  resources :restaurants do
    resources :transactions
  end

  resources :comments
  resources :orders

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1'  do
    get "/search/keyword" => "search#keyword"
    get "/search/filter" => "search#filter"
  end
  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
  	get "/getDishesByFilter" => "mains#getDishesByFilter"
  	get "/getRestaurantsByMap" => "restaurants#getRestaurantsByMap"
  end


end
