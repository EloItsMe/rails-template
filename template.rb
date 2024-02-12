# Stylesheets
########################################
run 'rm -rf app/assets/stylesheets'
run "curl -L https://github.com/EloItsMe/rails-stylesheet-structure/archive/refs/tags/release.zip > stylesheets.zip"
run "unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip"
run "mv app/assets/rails-stylesheet-structure-release app/assets/stylesheets"
########################################

# Test Framework
########################################
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

after_bundle do
  generate "rspec:install"

  replace_in_file 'spec/rails_helper.rb', "# Remove this line if you're not using ActiveRecord or ActiveRecord fixtures\nconfig.fixture_paths = [\nRails.root.join('spec/fixtures')\n]", ""

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
########################################