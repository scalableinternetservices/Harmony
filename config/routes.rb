Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "channels#index"
  resources :messages
  resources :users
  resources :channels do
    resources :messages
  end
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end
  resources :sessions
end
