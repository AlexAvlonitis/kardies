Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :user, skip: [:session, :password, :registration, :confirmation], controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get '/google24de39283b44c66d.html',
    to: proc { |env| [200, {}, ["google-site-verification: google24de39283b44c66d.html"]] }

  scope "(:locale)", locale: /gr|en/ do
    namespace :admin do
      get 'application/index'
      resources :reports, only: :index
      resources :users, only: :index
      resources :contacts, only: :index
    end

    get 'omniauth/:provider' => 'omniauth#localized', as: :localized_omniauth

    devise_for :user, skip: :omniauth_callbacks, controllers: { sessions: 'sessions', registrations: 'registrations' }

    devise_scope :user do
      delete 'delete_user/:username', to: "registrations#admin_destroy", as: :admin_destroy
      post 'unblock_user/:username', to: "registrations#admin_unblock", as: :admin_unblock
    end

    root 'home#index'

    resources :users, param: :username, only: [:index, :show] do
      member do
        put "like", to: "users#like"
        put "dislike", to: "users#unlike"
      end
    end

    get "likes", to: "likes#index", as: :my_likes
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

    resources :contacts, only: [:index, :create]

    get 'cities/:state', to: 'places#cities'

    get 'messages/:username/new', to: 'messages#new', as: :new_message
    post 'messages', to: 'messages#create', as: :messages

    # about, removed IDs
    get 'about/edit', to: 'abouts#edit',   as: :edit_about
    put 'about',      to: 'abouts#update', as: :about

    get 'terms', to: 'terms#index', as: :terms
  end
end
