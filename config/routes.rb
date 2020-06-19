Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :user

      put :about,            to: "abouts#update"
      put :email_preference, to: "email_preferences#update"
      put :galleries,        to: "galleries#update"

      post :store_membership, to: "memberships#store_membership"
      post :unsubscribe,      to: "cable#unsubscribe"
      post :golden_heart,     to: "golden_heart#create"
      post :messages,         to: "messages#create"
      post :message_reply,    to: "messages#reply"
      post :omniauths,        to: "omniauths#facebook"

      delete :blocked_users, to: "blocked_users#destroy"
      delete :users,         to: "users#destroy"
      delete :memberships,   to: "memberships#destroy"

      resources :users, param: :username, only: [:index, :show]

      resources :blocked_users,   only: [:create, :index]
      resources :personalities,   only: :create
      resources :reports,         only: :create
      resources :contacts,        only: :create
      resources :likes,           only: [:index, :create]
      resources :golden_users,    only: :index
      resources :search_criteria, only: :create, path: :search
      resources :pictures,        only: :destroy
      resources :memberships,     only: :create

      resources :conversations, only: [:index, :show, :destroy] do
        delete :delete_all, on: :collection
      end

      get :retrieve_membership, to: "memberships#retrieve_membership"
      get :states,              to: 'places#states'
      get :me,                  to: 'api#me'
    end
  end
end
