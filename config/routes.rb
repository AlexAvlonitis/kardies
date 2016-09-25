Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :users, only: [:index, :show] do
    resources :messages, only: [:new, :create]
    delete 'messages/:id/inbox', controller: 'messages',
                                 action: 'delete_received',
                                 as: :messages_delete_received
    delete 'messages/:id/sent', controller: 'messages',
                                action: 'delete_sent',
                                as: :messages_delete_sent
  end

  get 'messages', to: 'messages#index', as: :messages

  namespace :messages do
    get 'inbox', to: 'messages#index', as: :inbox
    get 'sent', to: 'messages#sent', as: :sent
  end
end
