Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :users, only: [:index, :show] do
    resources :messages, only: [:new, :create]
  end

  get 'messages', to: 'messages#index', as: :messages

  namespace :messages do
    get 'inbox', to: 'messages#index', as: :inbox
    get 'sent', to: 'messages#sent', as: :sent
  end
end
