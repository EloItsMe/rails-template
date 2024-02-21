# frozen_string_literal: true

require 'capybara/rails'

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    driven_by :rack_test
    driven_by :selenium_chrome_headless if example.metadata[:js]
    driven_by :selenium_chrome if example.metadata[:js_debug]
  end
end
