Rails.application.routes.draw do
  get 'message/post'
  get 'message/show'=>'message#show'
  post 'message/post'=>'message#create'
  post 'message/show'=>'message#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get "/channels", to: "channels#index"
  # get "/channels/:id", to: "channels#show"
  # get "/channels/new", to: "channels#new"
  # post "/channels", to: "channels#create"
  root "channels#index"
  resources :users
  resources :channels do
    post 'messages'=>'message#create'
    get 'messages'=>'message#create'
  end
end
