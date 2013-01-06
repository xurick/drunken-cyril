MdotApp::Application.routes.draw do

  namespace :mercury do
    resources :images
  end

  mount Mercury::Engine => '/'

  constraints(Subdomain) do
    match '/' => 'sites#show'
  end

  #special route to cafeori
  match '/' => 'sites#cafeori', :constraints => {:subdomain => 'cafeori'}

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
  #match '/test', to: 'main#test'

end
