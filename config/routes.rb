Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :account_balance, only: :show
    resources :transfers, only: :create
  end
end
