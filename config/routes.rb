Rails.application.routes.draw do
  post 'api/v1/users', to: 'users#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
