Rails.application.routes.draw do
  mount API::Engine => '/api'

  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'users/sessions',
                                    registrations: 'users/registrations',
                                    passwords: 'users/passwords'
                                  }
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    authenticated :user do
      root to: 'admin/dashboard#index', as: :authenticated_root
    end
    unauthenticated :user do
      root to: 'users/sessions#new', as: :unauthenticated_root
    end
  end
  # root to: 'sessions#new'
  root 'welcome#index'
end
