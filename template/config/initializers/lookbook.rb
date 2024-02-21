# frozen_string_literal: true

if Rails.env.development?
  Rails.application.configure do
    config.lookbook.project_name = 'Your App Name'
    config.lookbook.project_logo = false
    config.lookbook.ui_theme = 'zinc' # indigo, blue, zinc, green, rose.
  end
end
