Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  root to: 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products
  resources :orders

  resources :order_items, only: [:create]

  #Selecttag page flow n°2
  get '/select_tags', to: 'pages#select_tags'

end
