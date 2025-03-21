Rails.application.routes.draw do
  root "transactions#index"

  devise_for :users

  # rotas para as views
  resources :transactions, only: [:new, :create, :index]

  # rotas para o formato da API Rest
  namespace :api do
    namespace :v1 do
      resources :transactions, only: [:index, :show, :create]
    end
  end

end
