Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  root to: 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products
  resources :orders do
    get 'confirmation', on: :member
    resources :payments, only: [:new, :create]
    patch :select_gift_card
  end

  resources :order_items, only: [:create]
  resources :carts, only: [:new, :create, :edit, :update, :show] do
    resources :cart_products, only: [:new, :create]
    patch :surprise_me
    patch :reinitialize_cart
  end

  #Selecttag page flow n°2
  get '/select_tags', to: 'pages#select_tags'

end
