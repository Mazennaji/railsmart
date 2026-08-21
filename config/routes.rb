Rails.application.routes.draw do
  root "products#index"

  get    "signup", to: "users#new"
  post   "signup", to: "users#create"
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  resource :cart, only: [:show] do
    post   "add/:product_id",    to: "carts#add",    as: :add_item
    patch  "update/:product_id", to: "carts#update", as: :update_item
    delete "remove/:product_id", to: "carts#remove", as: :remove_item
  end

  resources :orders, only: [:index, :new, :create, :show] do
    member do
      get "success", to: "orders#success"
    end
  end

  namespace :admin do
    root "dashboard#index"
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update]
  end
end