after_bundle do
  # Stylesheets
  ########################################
  run 'rm -rf app/assets/stylesheets', verbose: false
  run "curl -L https://github.com/EloItsMe/rails-stylesheet-structure/archive/refs/tags/release.zip > stylesheets.zip", verbose: false
  run "unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip", verbose: false
  run "mv app/assets/rails-stylesheet-structure-release app/assets/stylesheets", verbose: false
  ########################################

# Rubocop
  ########################################
    # Add rubocop to the Gemfile
    # ----------------------------------------
    run "bundle add rubocop-rails --group 'development test'", verbose: false
    run "bundle add rubocop-rspec --group 'development test'", verbose: false
    run "bundle add rubocop-performance --group 'development test'", verbose: false
    run "bundle add rubocop-factory_bot --group 'development test'", verbose: false
    # ----------------------------------------
    # Create the .rubocop.yml file
    # ----------------------------------------
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
              - 'config/**/*'

          Style/Documentation:
            Enabled: false
          Style/EmptyMethod:
            Enabled: false
          Bundler/OrderedGems:
            Enabled: false
        YAML
      end
    # ----------------------------------------
  ########################################


  run "bundle add pundit"

  run "bundle add letter_opener --group development"
  run "bundle add bullet --group development"
  run "bundle add brakeman --group development"
  run "bundle add annotate --group development"

  run "bundle add dotenv-rails --group 'development test'"
  run "bundle add rspec-rails --group 'development test'"
  run "bundle add factory_bot_rails --group 'development test'"
  run "bundle add faker --group 'development test'"


  run "bundle add shoulda-matchers --group test"
  run "bundle add database_cleaner-active_record --group test"
  run "bundle add simplecov --group test"



  generate "pundit:install"

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

  insert_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false" do
    <<~RUBY
      \n
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = true
      config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end

  generate "bullet:install"

  gsub_file 'config/environments/development.rb', 'Bullet.bullet_logger = true', 'Bullet.bullet_logger = false'
  gsub_file 'config/environments/development.rb', 'Bullet.console       = true', 'Bullet.console       = false'
  gsub_file 'config/environments/development.rb', 'Bullet.rails_logger  = true', 'Bullet.rails_logger  = false'
  gsub_file 'config/environments/development.rb', 'Bullet.add_footer    = true', 'Bullet.add_footer    = false'
  gsub_file 'config/environments/test.rb', 'Bullet.bullet_logger = true', 'Bullet.bullet_logger = false'

  generate "annotate:install"
  gsub_file "lib/tasks/auto_annotate_models.rake", "'exclude_fixtures'            => 'false'", "'exclude_fixtures'            => 'true'"

  generate "rspec:install"

  gsub_file 'spec/rails_helper.rb', 'config.use_transactional_fixtures = true', 'config.use_transactional_fixtures = false'

  insert_into_file 'spec/rails_helper.rb', after: "# Add additional requires below this line. Rails is not loaded until this point!\n" do
    <<~RUBY
      Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
    RUBY
  end
  create_file 'spec/support/factory_bot.rb' do
    <<~RUBY
      RSpec.configure do |config|
        config.include FactoryBot::Syntax::Methods
      end
    RUBY
  end

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

  create_file 'spec/support/simplecov.rb' do
    <<~RUBY
      require 'simplecov'
      SimpleCov.start 'rails'
    RUBY
  end

  run "rubocop -A"
end
