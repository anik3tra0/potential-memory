Rails.application.routes.draw do
  resources :accounts
  resources :users
  post '/login' => 'users#login'
end
