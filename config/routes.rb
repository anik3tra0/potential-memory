Rails.application.routes.draw do
  resources :accounts, only: :create
  resources :users, only: [:create, :update]
  post '/login' => 'users#login'
end
