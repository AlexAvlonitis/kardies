Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :users, param: :username, only: [:index, :show],
                            constraints: { username: /[0-z\.]+/ } do
    member do
      put "like", to: "users#like"
      put "dislike", to: "users#unlike"
      get "likes", to: "users#my_likes", as: :my_likes
    end
  end

  # about, removed IDs
  get 'about/edit', to: 'abouts#edit',   as: :edit_about
  put 'about',      to: 'abouts#update', as: :about

end
