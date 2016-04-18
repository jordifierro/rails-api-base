require 'api_constraints.rb'

Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # Api definition
  scope module: :api, defaults: { format: :json }  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1,
                                                       default: true) do
      post   'users/login'  => 'sessions#create'
      delete 'users/logout' => 'sessions#destroy'
      resources :users, only: [:create, :destroy]
      resources :notes
      get 'versions/expiration' => 'versions#expiration'
    end
  end

  get 'users/confirm/:token', to: 'users#confirm', as: 'users_confirm'
  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'
end
