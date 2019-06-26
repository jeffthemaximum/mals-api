Rails.application.routes.draw do
  post 'api/v1/chats', to: 'chats#join_or_create'

  post 'api/v1/users', to: 'users#create'
  patch 'api/v1/users', to: "users#update"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
