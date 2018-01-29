Rails.application.routes.draw do
  # get 'sessions/new'

  root 'static_pages#home'
#  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'# , as: 'helf'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'session#new'
  get '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'
  resources :users
end
