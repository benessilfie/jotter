Rails.application.routes.draw do
  root to: "application#index"
  post "/", to: "graphql#execute"

  resources :users, except: %i[index]
  resources :notes

  namespace :auth do
    post "/login", to: "sessions#login"
    delete "/logout", to: "sessions#logout"
  end
end
