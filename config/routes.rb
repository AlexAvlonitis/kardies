Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :user

      put :about,            to: "abouts#update"
      put :email_preference, to: "email_preferences#update"
      put :galleries,        to: "galleries#update"
      put :search,           to: "search_criteria#update"

      post :unsubscribe,      to: "cable#unsubscribe"
      post :messages,         to: "messages#create"
      post :message_reply,    to: "messages#reply"

      delete :blocked_users, to: "blocked_users#destroy"
      delete :users,         to: "users#destroy"

      resources :users, param: :username, only: [:index, :show]

      resources :blocked_users,   only: [:create, :index]
      resources :personalities,   only: :create
      resources :reports,         only: :create
      resources :likes,           only: [:index, :create]
      resources :news,            only: [:index]
      resources :pictures,        only: :destroy

      resources :conversations, only: [:index, :show, :destroy] do
        collection do
          delete :delete_all
          get    :unread
        end
      end

      get :states,              to: 'places#states'
      get :me,                  to: 'api#me'
    end
  end
end
