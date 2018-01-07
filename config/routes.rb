Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'home#index'

  devise_for :user, controllers: { registrations: 'registrations',
                                   sessions: 'sessions',
                                   omniauth_callbacks: 'omniauth_callbacks' }

  get '/google24de39283b44c66d.html',
    to: proc { |env| [200, {}, ["google-site-verification: google24de39283b44c66d.html"]] }

  namespace :admin do
    get 'application/index', to: 'homes#index'
    resources :reports, only: :index
    resources :users, param: :username, only: [:index, :show]
    resources :contacts, only: :index
    resources :conversations, only: :show
    resources :blocked_emails, only: [:index, :destroy, :create]

    delete 'delete_user/:username', to: "users#admin_destroy", as: :destroy
    post 'unblock_user/:username', to: "users#admin_unblock", as: :unblock
    post 'create_admin/:username', to: "users#create_admin", as: :create_admin
    post 'undo_admin/:username', to: "users#undo_admin", as: :undo_admin
  end

  resources :users, param: :username, only: [:index, :show] do
    member do
      put "like", to: "likes#like"
      put "dislike", to: "likes#unlike"
    end
  end

  resources :reports, param: :username, only: [:create, :show]
  resources :search_criteria, only: [:new, :create]
  resources :contacts, only: [:index, :create]
  resources :email_preferences, only: [:edit, :update]

  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
    end
  end

  get "likes", to: "likes#index", as: :my_likes
  get 'cities/:state', to: 'places#cities'
  get 'messages/:username/new', to: 'messages#new',    as: :new_message
  get 'terms', to: 'terms#index', as: :terms

  post 'messages', to: 'messages#create', as: :messages

  # removed IDs
  get 'about/edit', to: 'abouts#edit',   as: :edit_about
  put 'about',      to: 'abouts#update', as: :about

  get 'gallery/edit', to: 'galleries#edit',   as: :edit_gallery
  put 'gallery',      to: 'galleries#update', as: :gallery

  delete 'delete_picture/:id', to: "pictures#destroy", as: :destroy_picture

  get 'email_preferences/edit', to: 'email_preferences#edit',   as: :edit_email_preferences
  put 'email_preferences',      to: 'email_preferences#update', as: :email_preferences

  # seo
  get 'site-gnorimion/σιτε-γνωριμιών', to: "gnorimies#site_gnorimion"
  get 'gnorimies-gamou/γνωριμίες-γάμου', to: "gnorimies#gnorimies_gamou"
  get 'gnorimies-athina/γνωριμίες-αθήνα', to: "gnorimies#gnorimies_athina"
end
