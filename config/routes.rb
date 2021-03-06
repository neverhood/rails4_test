Licemerov::Application.routes.draw do
  root to: "welcome#index"

  devise_for :users, controllers: { registrations: 'registrations' }

  # Profiles
  get '/profiles/:user_id' => 'profiles#show', as: 'user'

  # User Details
  get '/user_details/edit' => 'user_details#edit', as: 'edit_user'
  put '/user_details'      => 'user_details#update', as: 'user'

  # User avatar
  resource :user_avatar, only: [ :create, :update, :destroy ] # create: new avatar, update: crop avatar, destroy: remove avatar
end
