require 'api_constraints.rb'

RailsApiBase::Application.routes.draw do
  # Api definition
  scope module: :api, defaults: { format: :json }  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      post   'users/login'  => 'sessions#create'
      delete 'users/logout' => 'sessions#destroy'
      resources :users, only: [:create, :destroy]
      resources :notes
      get 'versions/expiration' => 'versions#expiration'
    end
  end
end
