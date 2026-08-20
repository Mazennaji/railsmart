Rails.application.routes.draw do
  root "products#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  resource :cart, only: [:show] do
    post   "add/:product_id",    to: "carts#add",    as: :add_item
    patch  "update/:product_id", to: "carts#update", as: :update_item
    delete "remove/:product_id", to: "carts#remove", as: :remove_item
    get    "signup", to: "users#new"
    post   "signup", to: "users#create"
    get    "login",  to: "sessions#new"
    post   "login",  to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end

  resources :orders, only: [:new, :create, :show]
end