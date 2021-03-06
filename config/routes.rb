Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions

  namespace :api do
    post 'token', to: 'token#create', as: :token_create
  end

  # Defines the root path route ("/")
  root "users#index"
end
