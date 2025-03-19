Rails.application.routes.draw do
  root "uploads#index"

  devise_for :users

  resources :uploads, only: [:new, :create, :index]
end
