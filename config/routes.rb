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

      # ajax btn
      get :paid
      get :completed
      get :cancelled
      get :big_bun

      # update order btn
      post :cancel_order
      post :not_yet_order
      post :yep_order

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
      post :yep_or_not
    end
  end

  resources :foods

  resources :restaurants do
    resources :orders, controller: :orders do
      member do
        post :transactions
      end
    end
  end

  resources :comments

  # resources :orders do
  #   member do
  #     post :transactions
  #   end
  # end

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1'  do
    get "/search/keyword" => "search#keyword"
    get "/search/filter" => "search#filter"
  end
  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
    get "/getDishesByFilter" => "mains#getDishesByFilter"
    get "/getRestaurantsByMap" => "restaurants#getRestaurantsByMap"
    get "/check_delivery_location" => "orders#check_delivery_location"
  end


end
