Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[ new create ]

  resources :posts, only: %i[ new create edit update ]

  resources :users, only: %i[ index show ] do
    resource :follow, only: %i[ create destroy ]
  end

  resource :profile, only: %i[ edit update ]
  resource :digest, only: :show

  get "up" => "rails/health#show", as: :rails_health_check

  root "digests#show"
end
