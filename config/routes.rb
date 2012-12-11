MdotApp::Application.routes.draw do

  #namespace :mercury do
    #resources :images
  #end

  #mount Mercury::Engine => '/'

  post "sites/create"

  get "sites/show"

  get "sites/test"

  put "sites/update"

  # by specifying 'resources', Rails automatically generates RESTful named routes
  resources :users

  # Since we have no need to show or edit sessions, we’ve restricted the actions to 
  # new, create, and destroy
  resources :sessions, only: [:new, :create, :destroy]

  constraints(Subdomain) do
    match '/' => 'users#show'
  end

  root to: 'main#home'

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'

  # Note the use of via: :delete for the signout route, which indicates that it 
  # should be invoked using an HTTP DELETE request.
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/help', to: 'main#help'

  match '/save', to: 'main#save'

  match '/load', to: 'main#load'

end
