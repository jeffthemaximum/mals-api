Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'chats', to: 'chats#join_or_create'
      post 'chats/:id/abort', to: 'chats#abort'
      post 'chats/:id/report', to: 'chats#report'

      get 'users', to: 'users#show'
      patch 'users', to: "users#update"
      patch 'users/:id/hide', to: "users#hide"
      post 'users', to: 'users#create'

      patch 'devices/:unique_id', to: 'devices#update'
      post 'devices', to: 'devices#get_or_create'

      resources :messages, only: [:create, :update, :index]
      resources :notifications, only: [:create]
    end
  end

  mount ActionCable.server => 'cable'
end
