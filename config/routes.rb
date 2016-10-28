Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  scope "(:locale)", locale: /gr|en/ do
    namespace :admin do
      get 'application/index'
      resources :reports, only: :index
      resources :users, only: :index
    end

    devise_for :user, controllers: { registrations: 'registrations', sessions: 'sessions' }

    devise_scope :user do
      delete 'delete_user/:username', to: "registrations#admin_destroy", as: :admin_destroy
      post 'unblock_user/:username', to: "registrations#admin_unblock", as: :admin_unblock
    end

    root to: "home#index"

    resources :users, param: :username, only: [:index, :show] do
      member do
        put "like", to: "users#like"
        put "dislike", to: "users#unlike"
        get "likes", to: "users#my_likes", as: :my_likes
      end
    end

    resources :reports, param: :username, only: [:new, :create, :show]

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
end
