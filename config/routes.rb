Rails.application.routes.draw do
  root to: "homepages#index"
  resources :works
end
