Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :subways, only: [:index] do
        get :most_stops, on: :collection
        get :least_stops, on: :collection
      end
  
      resources :stops, only: [] do
        get :connections, on: :collection
      end

      resources :paths, only: [:index] do
        get 'from/:from/to/:to', to: 'paths#index', on: :collection
      end
    end
  end
end
