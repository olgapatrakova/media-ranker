Rails.application.routes.draw do
  get 'votes/upvote'
  root to: "homepages#index"

  resources :works do
    post "/upvote", to: "votes#upvote", as: "upvote"
  end
  resources :users, only: [:index]

  get "users/login_form"
  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
  get "users/current", to: "users#current", as: "current_user"
end
