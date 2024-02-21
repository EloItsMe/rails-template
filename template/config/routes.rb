# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
    mount Lookbook::Engine, at: '/components' if Rails.env.development?
  end

  devise_for :users, path: 'auth', controllers: {
    confirmations: 'auths/confirmations',
    registrations: 'auths/registrations',
    sessions: 'auths/sessions',
    passwords: 'auths/passwords'
  }

  root to: 'pages#home'
end
