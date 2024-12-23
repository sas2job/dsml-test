Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get 'up' => 'rails/health#show', as: :rails_health_check
  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
  resources :users, only: %i[index edit update destroy]
  resources :leave_requests
  get '/all_requests', to: 'leave_requests#all_requests', as: :all_requests

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  resource :password_reset, only: %i[new create edit update]

  # Defines the root path route ("/")
  root 'welcome#index'
end
