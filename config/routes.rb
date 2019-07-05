Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'chats', to: 'chats#join_or_create'

      patch 'users', to: "users#update"
      post 'users', to: 'users#create'

      resources :messages, only: [:create, :update]
      resources :notifications, only: [:create]
    end
  end

  mount ActionCable.server => 'cable'
end
