Rails.application.routes.draw do
  get 'global_settings', to: 'global_settings#edit', as: 'global_settings'
  get 'screens_on', to: 'global_settings#screens_on', as: 'screens_on'
  get 'screens_off', to: 'global_settings#screens_off', as: 'screens_off'
  post 'global_settings', to: 'global_settings#update'

  devise_for :users, controllers: {
    omniauth_callbacks: 'auth'
  }

  presentation_superclass_methods = [:index, :show, :destroy]

  resources :users do
    get 'password', on: :member
    put 'password_update', on: :member
  end

  resources :presentations, only: presentation_superclass_methods do
    get 'display', on: :member
    get 'next', on: :collection
    get 'push', on: :member
    get 'preview', on: :member
    post 'mark_broken', on: :member
  end
  get 'presentations/:id/display/*path', to: 'presentations#display', format: false, as: 'display_presentation_path'
  get 'presentations/:id/preview/*path', to: 'presentations#display', format: false, as: 'display_preview_path'
  get 'presentations/card/:card', to: 'presentations#card', as: 'card_presentation'

  resources :slideshows, except: presentation_superclass_methods do
    resources :slides, shallow: true
  end

  resources :foldershows, except: presentation_superclass_methods

  resources :themes do
    resources :slideshows, shallow: true
  end

  get '/settings', to: 'users#settings', as: 'settings'
  get '/presentations', to: 'presentations#index', as: 'logged_in_home'
  get '/about', to: 'static#about', as: 'logged_out_home'
  get '/404', to: 'static#not_found', as: 'not_found'

  root 'presentations#index'

end
