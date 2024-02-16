REPO = "https://raw.githubusercontent.com/EloItsMe/rails-template/master"

def set_up_stylesheets
  remove_dir 'app/assets/stylesheets'
  run "curl -L 'https://github.com/EloItsMe/rails-stylesheet-structure/archive/refs/tags/release.zip' > stylesheets.zip"
  run "unzip stylesheets.zip && rm stylesheets.zip"
  run "mv rails-stylesheet-structure-release app/assets/stylesheets"
end

def install_rubocop
  run "bundle add rubocop --group 'development, test'"
  run "bundle add rubocop-rails --group 'development, test'"
  run "bundle add rubocop-rspec --group 'development, test'"
  run "bundle add rubocop-performance --group 'development, test'"
  run "bundle add rubocop-factory_bot --group 'development, test'"
end

def config_rubocop
  run "curl -L #{REPO + "/template/.rubocop.yml"} > .rubocop.yml"

  create_file 'config/initializers/rubocop.rb' do <<~RUBY
    if Rails.env.development?
      Rails.application.configure do
        config.generators.after_generate do |files|
          parsable_files = files.filter { |file| file.end_with?('.rb') }
          unless parsable_files.empty?
            system("bundle exec rubocop -A --fail-level=E {parsable_files.shelljoin}", exception: true)
          end
        end
      end
    end
  RUBY
  end
  
  gsub_file 'config/initializers/rubocop.rb', '{parsable_files.shelljoin}', '#{parsable_files.shelljoin}'
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
end

def install_brakeman
  run "bundle add brakeman --group development"
end

def install_bullet
  run "bundle add bullet --group development"
end

def config_bullet
  run "curl -L #{REPO + '/template/config/initializers/bullet.rb'} > config/initializers/bullet.rb"
end

def install_rspec
  run "bundle add rspec-rails --group 'development, test'"
  generate "rspec:install"
end

def config_rspec
  gsub_file 'spec/rails_helper.rb', "# Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }", "Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }"
  empty_directory 'spec/support'
end

def install_capybara
  run "bundle add capybara --group test"
end

def config_capbyara
  insert_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do <<~RUBY
    require 'capybara/rails'
  RUBY
  end
end

def install_factory_bot
  run "bundle add factory_bot_rails --group 'development, test'"
end

def config_factory_bot
  run "curl -L #{REPO + '/template/spec/support/factory_bot.rb'} > spec/support/factory_bot.rb"
end

def install_shoulda_matchers
  run "bundle add shoulda-matchers --group test"
end

def config_shoulda_matchers
  run "curl -L #{REPO + '/template/spec/support/shoulda_matchers.rb'} > spec/support/shoulda_matchers.rb"
end

def install_database_cleaner
  run "bundle add database_cleaner-active_record --group test"
end

def config_database_cleaner
  run "curl -L #{REPO + '/template/spec/support/database_cleaner.rb'} > spec/support/database_cleaner.rb"
end

def install_simplecov
  run "bundle add simplecov --group test"
end

def config_simplecov
  run "curl -L #{REPO + '/template/spec/support/simplecov.rb'} > spec/support/simplecov.rb"
end

def install_faker
  run "bundle add faker --group 'development, test'"
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
  run "bundle add dotenv-rails --group 'development, test'"
  create_file '.env'
end

def install_view_component
  run "bundle add view_component"
end

def config_view_component
  run "curl -L #{REPO + "/template/config/initializers/view_component.rb"} > config/initializers/view_component.rb"

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

def install_simple_form
  run "bundle add simple_form"
  generate "simple_form:install"
end

def config_simple_form
  remove_file "config/initializers/simple_form.rb"
  run "curl -L #{REPO + "/simple_form.rb"} > config/initializers/simple_form.rb"
end

def init_db
  rails_command "db:drop"
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end

def  init_git
  git init: %Q{ -b master }
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
  install_capybara
  config_capbyara
  install_factory_bot
  config_factory_bot
  install_shoulda_matchers
  config_shoulda_matchers
  install_database_cleaner
  config_database_cleaner
  install_simplecov
  config_simplecov
  install_faker

  # Admin

  # Utilities
  install_letter_opener
  config_letter_opener
  install_annotate
  config_annotate
  install_dotenv
  install_view_component
  config_view_component
  install_lookbook
  config_lookbook
  install_simple_form
  config_simple_form

  run "rubocop -A"
  init_db
  init_git
end
