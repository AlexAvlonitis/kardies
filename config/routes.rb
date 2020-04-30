Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :user

      resources :users, param: :username, only: [:index, :show] do
        member do
          put "like", to: "likes#create"
        end
      end

      put :about,            to: "abouts#update"
      put :email_preference, to: "email_preferences#update"
      put :galleries,        to: "galleries#update"

      post :store_membership, to: "memberships#store_membership"
      post :messages,         to: "messages#create"
      post :message_reply,    to: "messages#reply"
      post :omniauths,        to: "omniauths#facebook"

      delete :blocked_users, to: "blocked_users#destroy"
      delete :users,         to: "users#destroy"
      delete :memberships,   to: "memberships#destroy"

      resources :blocked_users,   only: [:create, :index]
      resources :personalities,   only: :create
      resources :reports,         only: :create
      resources :contacts,        only: :create
      resources :likes,           only: :index
      resources :golden_users,    only: :index
      resources :search_criteria, only: :create, path: :search
      resources :pictures,        only: :destroy
      resources :memberships,     only: :create

      resources :conversations, only: [:index, :show, :destroy] do
        delete :delete_all, on: :collection
      end

      get 'states', to: 'places#states'
      get 'me',     to: 'api#me'
    end
  end
end
