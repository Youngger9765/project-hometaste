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

  resources :users do
    member do
      get :purchase
      get :paid
      get :completed
      get :cancelled
      get :big_bun

      get :review
      get :like
      get :message
    end
  end

  resources :chefs do
    resources :foods
    resources :big_buns
    member do
      get :review
      get :approve

      # Menu
      get :add_dish
      post :save_dish
      get :add_big_bun
      get :menu

      # 5 btn
      get :sales
      get :summary
      get :advance
      get :delivering
      get :completed
      get :cancelled

      get :income
      get :rating
      get :message
      get :business

      #yep
      post :yep
    end
  end

  resources :foods
  resources :restaurants
  resources :comments
  resources :orders do
    member do
      post :transactions
    end
  end

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1'  do
    get "/search/keyword" => "search#keyword"
    get "/search/filter" => "search#filter"
  end
  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
    get "/getDishesByFilter" => "mains#getDishesByFilter"
    get "/getRestaurantsByMap" => "restaurants#getRestaurantsByMap"
  end


end
