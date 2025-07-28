Rails.application.routes.draw do
  apipie
  root to: 'homepage#index'

  devise_for :users

  devise_scope :user do
    delete '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  get '/homepage', to: 'homepage#index'
  resources :restaurants, only: %i[index new create]

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create show update destroy]
    end
  end
  resource :avatar, only: %i[edit update destroy]
end
