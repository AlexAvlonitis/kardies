Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'registrations' }

  root to: "home#index"

  mount ActionCable.server => '/cable'

  resources :users, param: :username, only: [:index, :show] do
    member do
      put "like", to: "users#like"
      put "dislike", to: "users#unlike"
      get "likes", to: "users#my_likes", as: :my_likes
    end
  end

  resources :galleries

  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
    end
    collection do
      delete :empty_trash
    end
  end

  get 'cities/:state', to: 'places#cities'

  get 'messages/:username/new', to: 'messages#new', as: :new_message
  post 'messages', to: 'messages#create', as: :messages

  # about, removed IDs
  get 'about/edit', to: 'abouts#edit',   as: :edit_about
  put 'about',      to: 'abouts#update', as: :about

end
