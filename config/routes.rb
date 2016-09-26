Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  root 'frontend#show'

  namespace :api do
    namespace :v1 do
      resources :meals, only: %i[index create update destroy], defaults: { format: :json }

      resource :settings, only: :update, defaults: { format: :json }

      resources :users, only: %i[index create update destroy], defaults: { format: :json }

      namespace :admin do
        resources :users, only: %i[index create update destroy], defaults: { format: :json }
        resources :meals, only: %i[index create update destroy], defaults: { format: :json }
      end
    end
  end
end
