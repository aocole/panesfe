Rails.application.routes.draw do
  resources :themes do
    resources :presentations, shallow: true
  end

  resources :users
  resources :presentations do
    get 'display', on: :member
    get 'next', on: :collection
    get 'push', on: :member
    resources :slides, shallow: true
  end

  get '/auth/:provider/callback', to: 'auth#callback'
  get '/auth', to: 'auth#index', as: 'login'
  get '/auth/logout', to: 'auth#logout', as: 'logout'
  get '/presentations', to: 'presentations#index', as: 'logged_in_home'
  get '/about', to: 'static#about', as: 'logged_out_home'
  get '/404', to: 'static#not_found', as: 'not_found'

  root 'presentations#index'

end
