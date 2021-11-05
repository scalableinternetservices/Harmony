Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get "/channels", to: "channels#index"
  # get "/channels/:id", to: "channels#show"
  # get "/channels/new", to: "channels#new"
  # post "/channels", to: "channels#create"

  resources :channels
end
