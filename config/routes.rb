Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :account_balance, only: :show
  end
end
