Rails.application.routes.draw do
  root "transactions#index"

  devise_for :users

  resources :transactions, only: [:new, :create, :index]
end
