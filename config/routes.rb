Rails.application.routes.draw do
  get 'dashboard/index'
  get '/homepage', to: 'homepage#index'
  root to: 'homepage#index'

  devise_for :users

  devise_scope :user do
    delete '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  resources :restaurants, only: %i[index new create] do
    resources :restaurant_tables, controller: 'restaurant_tables', only: %i[index new create edit update destroy]
  end

  resource :avatar, only: %i[edit update destroy]

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create show update destroy]
    end
  end
end
