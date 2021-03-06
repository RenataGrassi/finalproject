Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'
  resources :companies
  resources :products do
    resources :bookings, only: %i[create]
    resources :reviews, only: %i[index create]
    collection do
      get "day_trip"
      get "dive"
    end
  end

  post '/shopping_carts', to: "shopping_carts#create", as: "create_shopping_cart"
  resources :shopping_carts, only: %i[index create] do
    resources :payments, only: %i[new]
  end
  mount StripeEvent::Engine, at: '/stripe-webhooks'

  resources :bookings, only: %i[edit update destroy]

  # Company Routes
  namespace :company do
    resources :bookings, only: %i[index show destroy]
    resources :products, only: %i[index]
    resources :financials, only: %i[index]
    get '/', to: 'bookings#dashboard', as: 'dashboard'
    get '/charts/booking_chart', to: 'bookings#bookings_chart'
    get '/charts/product_chart', to: 'bookings#products_chart'
    get '/charts/participants_chart', to: 'bookings#participants_chart'
    get '/charts/financials_chart', to: 'bookings#financials_chart'
    patch 'bookings/:id/reactivate', to:'bookings#reactivate', as: 'booking_reactivate'
  end

  # Shopping cart custom routes
  get 'shopping_carts/current', to: 'shopping_carts#show', as: 'current_shopping_cart'

  resources :notifications, only: %i[index]

  get '/myproducts', to: 'products#my_index'

end
