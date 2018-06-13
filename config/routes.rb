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

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: :index

      post '/search', to: 'search_criteria#create', as: :search
      get 'cities/:state', to: 'places#cities'
      get 'states', to: 'places#states'
    end
  end

  resources :users, param: :username, only: [:index, :show] do
    member do
      put "like", to: "likes#like"
    end
  end

  resources :reports, param: :username, only: [:create, :show]
  resources :blocked_users, param: :id, only: [:create, :destroy]
  resources :contacts, only: [:index, :create]
  resources :email_preferences, only: [:edit, :update]

  resources :conversations, only: [:index, :show, :destroy] do
    delete :delete_all, on: :collection
  end

  get "likes", to: "likes#index", as: :my_likes
  get 'messages/:username/new', to: 'messages#new', as: :new_message
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

  get 'test-prosopikotitas', to: 'personalities#index', as: :get_personalities
  post 'test-prosopikotitas', to: 'personalities#create', as: :personalities

  # seo
  get 'site-gnorimion', to: "gnorimies#site_gnorimion"
  get 'gnorimies-gamou', to: "gnorimies#gnorimies_gamou"
  get 'gnorimies-athina', to: "gnorimies#gnorimies_athina"
end
