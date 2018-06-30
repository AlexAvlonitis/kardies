Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'users#index'

  use_doorkeeper do
    # No need to register client application
    skip_controllers :applications, :authorized_applications
  end

  get '/google24de39283b44c66d.html',
    to: proc { |env| [200, {}, ["google-site-verification: google24de39283b44c66d.html"]] }

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :user

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
        end
      end
      resources :reports, param: :username, only: [:create, :show]
      resources :blocked_users, param: :id, only: [:create, :destroy]
      resources :contacts,                  only: [:index, :create]
      resources :personalities,             only: [:index, :create]
      resources :email_preferences,         only: :update
      resources :galleries,                 only: :update
      resources :abouts,                    only: :update
      resources :messages,                  only: :create
      resources :like,                      only: :index
      resources :search_criteria,           only: :create, path: :search
      resources :pictures,                  only: :destroy
      resources :conversations, only: [:index, :show, :destroy] do
        delete :delete_all, on: :collection
      end

      get 'cities/:state',         to: 'places#cities'
      get 'states',                to: 'places#states'
      get 'me',                    to: 'api#me'
    end
  end

  get 'terms', to: 'terms#index', as: :terms
end
