Rails.application.routes.draw do
  root to: "homepage#index"

  devise_for :users

  # 👇 Add this block to define a custom logout route
  devise_scope :user do
    delete '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  get "/homepage", to: "homepage#index"
end
