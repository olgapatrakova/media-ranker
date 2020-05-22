Rails.application.routes.draw do
  get 'votes/upvote'
  root to: "homepages#index"

  resources :works do
    post "/upvote", to: "votes#upvote", as: "upvote"
  end
  resources :users, only: [:index, :show]

  get "users/login_form"
  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
end
