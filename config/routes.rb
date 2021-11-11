Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get "/channels", to: "channels#index"
  # get "/channels/:id", to: "channels#show"
  # get "/channels/new", to: "channels#new"
  # post "/channels", to: "channels#create"
  root "channels#index"
  resources :messages
  resources :users
  resources :channels do
    resources :messages
  end
  resources :sessions

  get :channel_refresh, controller: :channels

end
