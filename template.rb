def set_up_stylesheets
  run 'rm -rf app/assets/stylesheets'
  run "curl -L https://github.com/EloItsMe/rails-stylesheet-structure/archive/refs/tags/release.zip > stylesheets.zip"
  run "unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip"
  run "mv app/assets/rails-stylesheet-structure-release app/assets/stylesheets"
end

def install_rubocop
  run "bundle add rubocop --group 'development test'"
  run "bundle add rubocop-rails --group 'development test'"
  run "bundle add rubocop-rspec --group 'development test'"
  run "bundle add rubocop-performance --group 'development test'"
  run "bundle add rubocop-factory_bot --group 'development test'"
end

def config_rubocop
  create_file '.rubocop.yml' do
    <<~YAML
      require:
      - rubocop-rails
      - rubocop-performance
      - rubocop-rspec
      - rubocop-factory_bot

      AllCops:
        NewCops: enable
        Exclude:
          - 'bin/**/*'
          - 'lib/**/*'
          - 'config/environments/*'

      Style/Documentation:
        Enabled: false
      Style/EmptyMethod:
        Enabled: false
      Bundler/OrderedGems:
        Enabled: false
    YAML
  end
end

def install_pundit
  run "bundle add pundit"
  generate "pundit:install"
end

def pundit_config
  insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do
    <<~RUBY
      include Pundit::Authorization
    RUBY
  end

  create_file 'config/locales/pundit/en.yml' do
    <<~YAML
      en:
        pundit:
          default: "You are not allowed to perform this action."
    YAML
  end
end

def install_brakeman
  run "bundle add brakeman --group development"
end

def install_bullet
  run "bundle add bullet --group development"
  generate "bullet:install"
end

def config_bullet
  gsub_file 'config/environments/development.rb', 'Bullet.bullet_logger = true', 'Bullet.bullet_logger = false'
  gsub_file 'config/environments/development.rb', 'Bullet.console       = true', 'Bullet.console       = false'
  gsub_file 'config/environments/development.rb', 'Bullet.rails_logger  = true', 'Bullet.rails_logger  = false'
  gsub_file 'config/environments/development.rb', 'Bullet.add_footer    = true', 'Bullet.add_footer    = false'
end

def install_rspec
  run "bundle add rspec-rails --group 'development test'"
  generate "rspec:install"
end

def config_rspec
  gsub_file 'spec/rails_helper.rb', "# Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }", "Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }"
end

def install_factory_bot
  run "bundle add factory_bot_rails --group 'development test'"
end

def config_factory_bot
  create_file 'spec/support/factory_bot.rb' do
    <<~RUBY
      require 'factory_bot'

      RSpec.configure do |config|
        config.include FactoryBot::Syntax::Methods
      end
    RUBY
  end
end

def install_shoulda_matchers
  run "bundle add shoulda-matchers --group test"
end

def config_shoulda_matchers
  create_file 'spec/support/shoulda_matchers.rb' do
    <<~RUBY
      Shoulda::Matchers.configure do |config|
        config.integrate do |with|
          with.test_framework :rspec
          with.library :rails
        end
      end
    RUBY
  end
end

def install_database_cleaner
  run "bundle add database_cleaner-active_record --group test"
end

def config_database_cleaner
  create_file 'spec/support/database_cleaner.rb' do
    <<~RUBY
      RSpec.configure do |config|
        config.before(:suite) do
          DatabaseCleaner.clean_with :truncation, except: %w(ar_internal_metadata)
        end

        config.before(:each) do
          DatabaseCleaner.strategy = :transaction
        end

        config.before(:each) do
          DatabaseCleaner.start
        end

        config.after(:each) do
          DatabaseCleaner.clean
        end
      end
    RUBY
  end
end

def install_simplecov
  run "bundle add simplecov --group test"
end

def config_simplecov
  create_file 'spec/support/simplecov.rb' do
    <<~RUBY
      require 'simplecov'
      SimpleCov.start 'rails'
    RUBY
  end
end

def install_faker
  run "bundle add faker --group 'development test'"
end

def install_letter_opener
  run "bundle add letter_opener --group development"
end

def config_letter_opener
  insert_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false" do
    <<~RUBY
      \n
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = true
      config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end
end

def install_annotate
  run "bundle add annotate --group development"
  generate "annotate:install"
end

def config_annotate
  gsub_file 'lib/tasks/auto_annotate_models.rake', "'exclude_fixtures'            => 'false'", "'exclude_fixtures'            => 'true'"
end

def install_dotenv
  run "bundle add dotenv-rails --group 'development test'"
  create_file '.env'
end

def install_view_component
  run "bundle add view_component"
end

def config_view_component
  insert_into_file 'config/initializers/assets.rb', after: "# Add additional assets to the asset load path.\n" do <<~RUBY
    Rails.application.config.assets.paths << Rails.root.join("app/components")
  RUBY
  end

  insert_into_file 'app/assets/config/manifest.js', after: "//= link_tree ../../javascript .js\n" do <<~JS
    //= link_tree ../../components .js
  JS
  end

  insert_into_file 'app/javascript/controllers/index.js', after: `eagerLoadControllersFrom("controllers", application)\n` do <<~RUBY
    eagerLoadControllersFrom("components", application)
  RUBY
  end

  insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<~RUBY
    config.view_component.generate.preview = true
    config.view_component.preview_paths << "spec/components/previews"
  RUBY
  end

  run "mkdir app/components"
end

def install_lookbook
  run "bundle add lookbook --group development"
end

def config_lookbook
  insert_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<~RUBY
    if Rails.env.development?
      mount Lookbook::Engine, at: "/components"
    end
  RUBY
  end
end

def config_generators
  insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<~RUBY
    config.generators do |generate|
      generate.test_framework :rspec
      generate.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  RUBY
  end
end

def init_db
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end

def  init_git
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

after_bundle do
  # Stylesheets
  set_up_stylesheets

  # Linter
  install_rubocop
  config_rubocop

  # Security
  install_pundit
  pundit_config
  install_brakeman
  install_bullet
  config_bullet

  # Testing
  install_rspec
  config_rspec
  install_factory_bot
  config_factory_bot
  install_shoulda_matchers
  config_shoulda_matchers
  install_database_cleaner
  config_database_cleaner
  install_simplecov
  config_simplecov
  install_faker

  # Generators
  config_generators

  # Admin

  # Utilities
  install_letter_opener
  config_letter_opener
  install_annotate
  config_annotate
  install_dotenv
  install_view_component
  config_view_component

  run "rubocop -A"
  init_db
  init_git
end
