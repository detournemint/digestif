Rails.application.routes.draw do
  root to: 'pages#main'
  resources :posts, only: [:new, :create, :index]
end
