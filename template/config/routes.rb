# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Lookbook::Engine, at: '/components' if Rails.env.development?
  end

  devise_for :users
  root to: 'pages#home'
end
