Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/home_admin', as: 'rails_admin'
  get 'transactions/new'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "main#index"

  get "main/index" => "main#index"
  get "admin" => "admin/users#index"


  get 'conditions' => 'main#conditions'
  get 'terms' => 'main#terms'

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
      get :message

      get :liked
      get :kitchen
      get :food

      post :like
      post :unlike

      # conversation
      get :get_conversation_messages

    end
  end

  resources :chefs do
    resources :foods
    resources :big_buns
    resources :replies
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

      #report
      get :orders_to_csv

      # conversation
      get :get_conversation_messages

    end
  end

  resources :foods

  resources :restaurants do
    resources :orders, controller: :orders do
      member do
        post :transactions
      end
    end

    resources :comments do
      member do
        post :update_food_comment
      end

      collection do
        post :create_food_comment
      end
    end

    member do
      get :get_conversation_with_chef
    end
  end

  resources :big_buns do
    collection do
      post :user_get_big_bun
      post :user_send_big_bun_as_gift
    end
  end

  resources :conversations, only: [:create] do
    member do
      post :close
    end

    resources :messages, only: [:create]
  end



  # resources :orders do
  #   member do
  #     post :transactions
  #   end
  # end

  scope path: '/api/v1/', module: 'api_v1', as: 'v1'  do
    get '/search/keyword' => 'search#keyword'
    get '/search/filter' => 'search#filter'
    get '/cuisines/get_foods' => 'cuisines#get_foods'
    get '/cuisines/get_restaurants' => 'cuisines#get_restaurants'
  end
  scope path: '/api/v1/', module: 'api_v1', as: 'v1', defaults: { format: :json } do
    get '/getDishesByFilter' => 'mains#getDishesByFilter'
    get '/getRestaurantsByMap' => 'restaurants#getRestaurantsByMap'
    get '/check_delivery_location' => 'orders#check_delivery_location'
  end


end
