Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'auth'
  }

  resources :users
resources :presentations, only: [:index, :show, :destroy] do
    get 'display', on: :member
    get 'next', on: :collection
    get 'push', on: :member
  end

  resources :slideshows do
    resources :slides, shallow: true
  end

  resources :foldershows

  resources :themes do
    resources :slideshows, shallow: true
  end

  get '/presentations', to: 'presentations#index', as: 'logged_in_home'
  get '/about', to: 'static#about', as: 'logged_out_home'
  get '/404', to: 'static#not_found', as: 'not_found'

  root 'presentations#index'

end
