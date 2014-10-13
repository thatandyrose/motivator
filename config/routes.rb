Motivator::Application.routes.draw do
  root to: "home#index"
  
  resources :users, only: [:index, :show, :edit, :update]

  resources :motees, only: [:index, :new, :create]

  resources :sessions, except: [:new, :create, :destroy]
  
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#failure'
end
