Licemerov::Application.routes.draw do
  root to: "welcome#index"

  devise_for :users, controllers: { registrations: 'registrations' }

  # Profiles
  post '/profiles'         => 'profiles#create', as: 'profile_posts'
  get '/profiles/:user_id' => 'profiles#show',   as: 'user'

  # Feed
  get '/news' => 'news_feed_entries#index', as: 'feed'

  # Responses
  get '/responses' => 'response_entries#index', as: 'responses'

  # Users search
  get '/users_search' => 'users_search#show',    as: 'users_search'
  post '/users_search' => 'users_search#create', as: 'create_users_search'

  # User Details
  get '/user_details/edit' => 'user_details#edit', as: 'edit_user'
  put '/user_details'      => 'user_details#update', as: 'update_user'

  # User avatar
  resource :user_avatar, only: [ :create, :update, :destroy ] # create: new avatar, update: crop avatar, destroy: remove avatar

  # Subscriptions
  resource :subscriptions, only: [ :create, :destroy ]
  #get '/subscriptions' => 'subscriptions#index', as: 'subscriptions'

  # Conversations
  resources :conversations, only: [ :destroy, :show, :index ]
  resources :messages,      only: [ :create, :destroy ]

  # Albums
  get '/profiles/:user_id/albums' => 'albums#index', as: 'user_albums'
  get '/profiles/:user_id/albums/:album_name' => 'albums#show', as: 'user_album'
  resources :albums, only: [ :create, :update, :destroy, :new, :edit ]

  # Photos
  get '/profiles/:user_id/photos'     => 'photos#index', as: 'user_photos'
  get '/profiles/:user_id/photos/:id' => 'photos#show',  as: 'user_photo'
  resources :photos, only: [ :create, :update, :destroy, :show ] do
    get :edit, :on => :collection
  end

  # Photo comments
  resources :photo_comments, only: [ :create, :update, :destroy ]



  # Cities and countries
  get '/countries' => 'countries#index'
  get '/cities'    => 'cities#index'

end
