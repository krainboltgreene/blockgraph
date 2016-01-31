Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  devise_for :accounts, controllers: {
    omniauth_callbacks: "accounts/omniauth_callbacks"
  }

  resources :blocks
end
