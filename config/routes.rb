Rails.application.routes.draw do
  root "application#ent"
  get 'message/post'
  get 'message/show'=>'message#show'
  post 'message/post'=>'message#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
