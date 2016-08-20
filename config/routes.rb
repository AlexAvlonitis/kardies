Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :places

  resources :users, only: [:index, :show] do
    resources :posts
    resources :messages, only: [:new, :create]
  end

  resources :messages, only: [:index]

  get 'countries/:country', to: 'places#states'
  get 'cities/:state', to: 'places#cities'
end
