Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'chats', to: 'chats#join_or_create'
      post 'chats/:id/leave', to: 'chats#leave'

      patch 'users', to: "users#update"
      post 'users', to: 'users#create'

      resources :messages, only: [:create, :update, :index]
      resources :notifications, only: [:create]
    end
  end

  mount ActionCable.server => 'cable'
end
