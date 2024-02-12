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
end
########################################
