MdotApp::Application.routes.draw do

  namespace :mercury do
    resources :images
  end

  mount Mercury::Engine => '/'

  constraints(Subdomain) do
    match '/' => 'sites#show'
  end

  root :to => 'main#home'

  get 'main/home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :sites
  resources :comments
  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  # testing
  match '/test', to: 'main#test'

  # temporary for Cafe Ori test
  get "sites/test"

end
