Rails.application.routes.draw do
  get "carts/show"
  root "products#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  resource :cart, only: [:show] do
    post   "add/:product_id",    to: "carts#add",    as: :add_item
    patch  "update/:product_id", to: "carts#update", as: :update_item
    delete "remove/:product_id", to: "carts#remove", as: :remove_item
  end

  resources :orders, only: [:new, :create, :show]
end