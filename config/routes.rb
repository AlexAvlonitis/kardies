Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'registrations', sessions: 'sessions' }

  root to: "home#index"

  resources :users, param: :username, only: [:index, :show],
                            constraints: { username: /[0-z\.]+/ } do
    resources :messages, only: [:new, :create]
    delete 'messages/:id/inbox', controller: 'messages',
                                 action: 'delete_received',
                                 as: :messages_delete_received
    delete 'messages/:id/sent', controller: 'messages',
                                action: 'delete_sent',
                                as: :messages_delete_sent
    member do
      put "like", to: "users#like"
      put "dislike", to: "users#unlike"
      get "likes", to: "users#my_likes", as: :my_likes
    end
  end

  # about, removed IDs
  get 'about/edit', to: 'abouts#edit',   as: :edit_about
  put 'about',      to: 'abouts#update', as: :about

  get 'messages', to: 'messages#index', as: :messages

  namespace :messages do
    get 'inbox', to: 'messages#index', as: :inbox
    get 'sent',  to: 'messages#sent',  as: :sent
  end
end
