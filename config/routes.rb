Rails.application.routes.draw do
  apipie
  root to: 'homepage#index'

  devise_for :users

  devise_scope :user do
    delete '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  get '/homepage', to: 'homepage#index'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create]
    end
  end
end
