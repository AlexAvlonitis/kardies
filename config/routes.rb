Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :places
  resources :users, only: [:index]

  get 'countries/:country', to: 'places#states'
  get 'cities/:state', to: 'places#cities'
end
