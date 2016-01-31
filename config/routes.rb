Rails.application.routes.draw do
  resources :blocks
  devise_for :accounts, controllers: {
    omniauth_callbacks: "accounts/omniauth_callbacks"
  }
end
