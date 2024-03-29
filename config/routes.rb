# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post 'phase/:id', to: 'phases#engineer', as: 'phase_engineers'
  get 'phase/:id', to: 'phases#complete', as: 'phase_complete'
  get 'lead/:id', to: 'leads#close', as: 'lead_close'
  get 'projects' , to: 'leads#project_index' , as:'projects_index'

  resources :leads do
    resources :comments, only: %i[create destroy]
    resources :phases do
      resources :comments, only: %i[create destroy]
    end
  end

  root to: 'leads#index'
end
