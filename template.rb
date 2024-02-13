# Stylesheets
########################################
run 'rm -rf app/assets/stylesheets'
run "curl -L https://github.com/EloItsMe/rails-stylesheet-structure/archive/refs/tags/release.zip > stylesheets.zip"
run "unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip"
run "mv app/assets/rails-stylesheet-structure-release app/assets/stylesheets"
########################################

# Gemfile
########################################
gem_group :development do
  gem "letter_opener"
  gem "bullet"
  gem 'brakeman'
  gem 'annotate'
end

gem_group :development, :test do
  gem "dotenv-rails"
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

gem_group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
end
########################################


after_bundle do
  insert_into_file 'config/evironments/development.rb', after: "config.action_mailer.raise_delivery_errors = false" do
    <<~RUBY
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = true
      config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end

  generate "bullet:install"

  # gsub_file 'config/environments/development.rb', 'Bullet.bullet_logger = true', 'Bullet.bullet_logger = false'
  # gsub_file 'config/environments/development.rb', 'Bullet.console       = true', 'Bullet.console       = false'
  # gsub_file 'config/environments/development.rb', 'Bullet.rails_logger  = true', 'Bullet.rails_logger  = false'
  # gsub_file 'config/environments/development.rb', 'Bullet.add_footer    = true', 'Bullet.add_footer    = false'
  # gsub_file 'config/environments/test.rb', 'Bullet.bullet_logger = true', 'Bullet.bullet_logger = false'

  generate "annotate:install"
  # gsub_file "'exclude_fixtures'            => 'false'","'exclude_fixtures'            => 'true'"

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
end
