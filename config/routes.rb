# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post 'phase/:id', :to => 'phases#engineer', as: 'phase_engineers'
  get 'phase/:id', :to => 'phases#complete', as: 'phase_complete'
  get 'lead/:id', :to => 'leads#close', as: 'lead_close'

  devise_for :users
  resources :leads do
    resources :comments, only: %i[create destroy]
    resources :phases do
      resources :comments, only: %i[create destroy]
    end
  end

  resources :phases do
    resources :comments, only: %i[create destroy]
  end

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
