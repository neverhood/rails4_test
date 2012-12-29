Licemerov::Application.routes.draw do
  root to: "welcome#index"

  devise_for :users, controllers: { registrations: 'registrations' }

  # Profiles
  get '/profiles/:user_id' => 'profiles#show', as: 'user'

  # User Details
  get '/user_details/edit' => 'user_details#edit', as: 'edit_user'
  put '/user_details'      => 'user_details#update', as: 'update_user'

  # User avatar
  resource :user_avatar, only: [ :create, :update, :destroy ] # create: new avatar, update: crop avatar, destroy: remove avatar

  # Subscriptions
  resource :subscriptions, only: [ :create, :destroy, :index ]
  get '/subscriptions' => 'subscriptions#index', as: 'subscriptions'

  # Conversations
  resources :conversations, only: [ :destroy, :show, :index ]
  resources :messages,      only: [ :create, :destroy ]
end
