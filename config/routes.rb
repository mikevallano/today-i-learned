Rails.application.routes.draw do


  resources :reflections
  resources :reflections
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :users, only: [:show], as: :user

  root 'pages#home'
  get 'pages/about'
  get 'pages/awaiting_confirmation', as: :awaiting_confirmation

end
