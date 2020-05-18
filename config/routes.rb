Rails.application.routes.draw do
  get 'users/login_form'
  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
  get "users/current", to: "users#current", as: "current_user"

  root to: "homepages#index"

  resources :works
  resources :users, only: [:index]
end
