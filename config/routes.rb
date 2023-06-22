Rails.application.routes.draw do
  get 'sessions/new'
  root 'sessions#new'
  resources :sessions, only: [:new, :create, :show, :destroy]
  resources :users, only: [:new, :show, :create, :destroy]
  resources :tasks do
    collection do
      post :confirm
    end
  end
  namespace :admin do
    resources :users
    resources :labels, except: :show
  end
end
