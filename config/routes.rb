Rails.application.routes.draw do
  mount API::Engine => "/api"

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
