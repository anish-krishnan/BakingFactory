Rails.application.routes.draw do
  
  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :item_prices
  resources :users

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'cart' => 'home#cart', as: :cart
  get 'shipinfo' => 'home#shipinfo', as: :shipinfo
  get 'bakeinfo' => 'home#bakeinfo', as: :bakeinfo
  get 'dash', to: 'home#dash', as: :dash
  get 'home/search', to: 'home#search', as: :search
  get 'home/cart_reset', to: 'home#cart_reset', as: :cartReset

  # post 'item/cart', :to => 'item#addToCart', as: :cart_item
  get 'items/:id/addToCart', to: 'items#addToCart', as: :addToCart_Item
  get 'items/:id/deleteFromCart', to: 'items#deleteFromCart', as: :deleteFromCart_Item
  get 'customer/:id/activate', to: 'customers#activate', as: :activate_Customer
  get 'customer/:id/deactivate', to: 'customers#deactivate', as: :deactivate_Customer
  get 'item/:id/activate', to: 'items#activate', as: :activate_Item
  get 'item/:id/deactivate', to: 'items#deactivate', as: :deactivate_Item
  get 'user/:id/activate', to: 'users#activate', as: :activate_User
  get 'user/:id/deactivate', to: 'users#deactivate', as: :deactivate_User
  get 'address/:id/remove', to: 'addresses#remove', as: :remove_address
  get 'order/checkout', to: 'orders#checkout', as: :checkout_order

  get 'order_item/:id/toggleshipped', to: 'order_items#toggleshipped', as: :toggle_shipped


  # Authentication routes
  resources :sessions
  resources :users
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  
  # Set the root url
  root :to => 'home#home'
  
end
