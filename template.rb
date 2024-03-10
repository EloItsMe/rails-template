REPO = "https://raw.githubusercontent.com/EloItsMe/rails-template/master"

def set_up_stylesheets
  remove_file "app/assets/stylesheets/application.sass.css"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/application.sass.scss"} > app/assets/stylesheets/application.sass.scss"

  empty_directory 'app/assets/stylesheets/config'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/config/_breakpoints.scss"} > app/assets/stylesheets/config/_breakpoints.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/config/_colors.scss"} > app/assets/stylesheets/config/_colors.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/config/_typographies.scss"} > app/assets/stylesheets/config/_typographies.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/config/_reset.scss"} > app/assets/stylesheets/config/_reset.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/config/index.scss"} > app/assets/stylesheets/config/index.scss"

  empty_directory 'app/assets/stylesheets/components'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/_button.scss"} > app/assets/stylesheets/components/_button.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/_flash.scss"} > app/assets/stylesheets/components/_flash.scss"
  empty_directory 'app/assets/stylesheets/components/form'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/form/_input.scss"} > app/assets/stylesheets/components/form/_input.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/form/_text.scss"} > app/assets/stylesheets/components/form/_text.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/form/_wrapper.scss"} > app/assets/stylesheets/components/form/_wrapper.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/form/_checkbox.scss"} > app/assets/stylesheets/components/form/_checkbox.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/form/index.scss"} > app/assets/stylesheets/components/form/index.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/components/index.scss"} > app/assets/stylesheets/components/index.scss"

  empty_directory 'app/assets/stylesheets/externals'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/externals/index.scss"} > app/assets/stylesheets/externals/index.scss"

  empty_directory 'app/assets/stylesheets/layouts'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/layouts/index.scss"} > app/assets/stylesheets/layouts/index.scss"

  empty_directory 'app/assets/stylesheets/pages'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/pages/index.scss"} > app/assets/stylesheets/pages/index.scss"

  empty_directory 'app/assets/stylesheets/utilities'
  run "curl -L #{REPO + "/template/app/assets/stylesheets/utilities/_display.scss"} > app/assets/stylesheets/utilities/_display.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/utilities/_margin.scss"} > app/assets/stylesheets/utilities/_margin.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/utilities/_padding.scss"} > app/assets/stylesheets/utilities/_padding.scss"
  run "curl -L #{REPO + "/template/app/assets/stylesheets/utilities/index.scss"} > app/assets/stylesheets/utilities/index.scss"
end

def set_up_assets
  run "curl -L #{REPO + "/template/config/initializers/asset_url_processor.rb"} > config/initializers/asset_url_processor.rb"
  empty_directory 'app/assets/images/icons'
  run "curl -L #{REPO + "/template/app/assets/images/icons/x-mark.svg"} > app/assets/images/icons/x-mark.svg"
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
  run "curl -L #{REPO + '/template/spec/support/pundit.rb'} > spec/support/pundit.rb"
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

def install_bundler_audit
  run "bundle add bundler-audit --group development"
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
  run "bundle add selenium-webdriver --group test"
end

def config_capybara
  run "curl -L #{REPO + '/template/spec/support/capybara.rb'} > spec/support/capybara.rb"
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
  run "bundle add database_cleaner-active_record --group 'development, test'"
end

def config_database_cleaner
  run "curl -L #{REPO + '/template/spec/support/database_cleaner.rb'} > spec/support/database_cleaner.rb"
end

def install_simplecov
  run "bundle add simplecov --group test"
  run "bundle add simplecov-cobertura --group test"
end

def config_simplecov
  insert_into_file 'spec/spec_helper.rb' do <<~RUBY
    require 'simplecov'
    require 'simplecov-cobertura'
    SimpleCov.start 'rails' do
      formatter SimpleCov::Formatter::MultiFormatter.new([
                                                          SimpleCov::Formatter::HTMLFormatter,
                                                          SimpleCov::Formatter::CoberturaFormatter
                                                        ])
      add_filter '/jobs/application_job.rb'
      add_filter '/helpers/application_helper.rb'
      add_filter '/mailers/application_mailer.rb'
      add_filter '/models/application_record.rb'
      add_filter '/channels/application_cable/channel.rb'
      add_filter '/channels/application_cable/connection.rb'
      add_filter '/controllers/auths'
      add_filter '/helpers/svg_helper.rb'
      add_filter '/components/typographie/typographie_component.rb'
      add_filter '/components/form/input/input_component.rb'
      add_filter '/policies/application_policy.rb'
      add_filter '/admin'
    end
  RUBY
  end
end

def install_faker
  run "bundle add faker --group 'development, test'"
end

def install_sidekiq
  run "bundle add sidekiq"
end

def config_sidekiq
  insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<~RUBY
    config.active_job.queue_adapter = :sidekiq
  RUBY
  end
end

def install_letter_opener
  run "bundle add letter_opener --group development"
end

def config_letter_opener
  insert_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false" do <<~RUBY
      \n
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = true
      config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end

  insert_into_file 'config/environments/test.rb', after: "config.action_mailer.delivery_method = :test" do <<~RUBY
    \n
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
  run "curl -L #{REPO + '/template/app/views/layouts/component.html.erb'} > app/views/layouts/component.html.erb"
  run "curl -L #{REPO + '/template/config/initializers/view_component.rb'} > config/initializers/view_component.rb"
  run "curl -L #{REPO + '/template/lib/tasks/stimulus_tasks.rake'} > lib/tasks/stimulus_tasks.rake"
  run "curl -L #{REPO + '/template/spec/support/view_component.rb'} > spec/support/view_component.rb"
  empty_directory 'app/components'
  empty_directory 'spec/components'
  empty_directory 'spec/components/previews'
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
  run "curl -L #{REPO + '/template/config/initializers/lookbook.rb'} > config/initializers/lookbook.rb"
end

def install_simple_form
  run "bundle add simple_form"
  generate "simple_form:install"
end

def config_simple_form
  remove_file "config/initializers/simple_form.rb"
  run "curl -L #{REPO + '/template/config/initializers/simple_form.rb'} > config/initializers/simple_form.rb"
end

def config_svg_helper
  run "curl -L #{REPO + '/template/app/helpers/svg_helper.rb'} > app/helpers/svg_helper.rb"
end

def install_devise
  run "bundle add devise"
  generate "devise:install"
  generate "devise user admin:boolean"
  generate "devise:controllers auths -v confirmations registrations sessions passwords"
  generate "devise:views auths"
end

def config_devise
  migration_file_name = ask("What is the name of the migration file for the users table? (include the .rb extension)")
  migration_file_name.strip!
  gsub_file "db/migrate/#{migration_file_name}", "def change", "def change # rubocop:disable Metrics/MethodLength"
  gsub_file "db/migrate/#{migration_file_name}", " # t.string   :confirmation_token", " t.string   :confirmation_token"
  gsub_file "db/migrate/#{migration_file_name}", " # t.datetime :confirmed_at", " t.datetime :confirmed_at"
  gsub_file "db/migrate/#{migration_file_name}", " # t.datetime :confirmation_sent_at", " t.datetime :confirmation_sent_at"
  gsub_file "db/migrate/#{migration_file_name}", " # t.string   :unconfirmed_email # Only if using reconfirmable", " t.string   :unconfirmed_email"
  gsub_file "db/migrate/#{migration_file_name}", " t.boolean :admin", " t.boolean :admin, null: false, default: false"
  gsub_file "db/migrate/#{migration_file_name}", " # add_index :users, :confirmation_token,   unique: true", " add_index :users, :confirmation_token,   unique: true"
  remove_file "config/initializers/devise.rb"
  run "curl -L #{REPO + '/template/config/initializers/devise.rb'} > config/initializers/devise.rb"
  run "curl -L #{REPO + '/template/spec/support/devise.rb'} > spec/support/devise.rb"
  remove_file "app/models/user.rb"
  run "curl -L #{REPO + '/template/app/models/user.rb'} > app/models/user.rb"
  remove_file "spec/factories/users.rb"
  run "curl -L #{REPO + '/template/spec/factories/users.rb'} > spec/factories/users.rb"
  remove_file "spec/models/user_spec.rb"
  run "curl -L #{REPO + '/template/spec/models/user_spec.rb'} > spec/models/user_spec.rb"
  insert_into_file 'app/controllers/application_controller.rb', after: "include Pundit::Authorization\n" do <<~RUBY

    before_action :authenticate_user!
  RUBY
  end
  empty_directory 'app/views/pages'
  run "curl -L #{REPO + '/template/app/views/pages/home.html.erb'} > app/views/pages/home.html.erb"
  run "curl -L #{REPO + '/template/app/controllers/pages_controller.rb'} > app/controllers/pages_controller.rb"

  remove_file "config/routes.rb"
  run "curl -L #{REPO + '/template/config/routes.rb'} > config/routes.rb"

  empty_directory 'spec/requests'
  run "curl -L #{REPO + '/template/spec/requests/pages_spec.rb'} > spec/requests/pages_spec.rb"

  remove_dir 'app/views/auths/unlocks'
  remove_file 'app/views/auths/mailer/unlock_instructions.html.erb'
end

def install_active_admin
  run "bundle add activeadmin"
  run "bundle add sassc-rails"
  generate "active_admin:install user --skip-users"
  run "bundle add activeadmin_addons"
  generate "activeadmin_addons:install"
end

def config_active_admin
  run "curl -L #{REPO + '/template/app/models/application_record.rb'} > app/models/application_record.rb"
end

def set_up_github_action
  empty_directory '.github/workflows'
  run "curl -L #{REPO + '/template/.github/workflows/linter.yml'} > .github/workflows/linter.yml"
  run "curl -L #{REPO + '/template/.github/workflows/test.yml'} > .github/workflows/test.yml"
  run "curl -L #{REPO + '/template/.github/workflows/security.yml'} > .github/workflows/security.yml"
end

def set_up_github_PR_template
  run "curl -L #{REPO + '/template/.github/pull_request_template.md'} > .github/pull_request_template.md"
  empty_directory '.github/PULL_REQUEST_TEMPLATE'
  run "curl -L #{REPO + '/template/.github/PULL_REQUEST_TEMPLATE/default_template.md'} > .github/PULL_REQUEST_TEMPLATE/default_template.md"
  run "curl -L #{REPO + '/template/.github/PULL_REQUEST_TEMPLATE/hotfix_template.md'} > .github/PULL_REQUEST_TEMPLATE/hotfix_template.md"
  run "curl -L #{REPO + '/template/.github/PULL_REQUEST_TEMPLATE/merge_dev_into_main_template.md'} > .github/PULL_REQUEST_TEMPLATE/merge_dev_into_main_template.md"
  run "curl -L #{REPO + '/template/.github/PULL_REQUEST_TEMPLATE/merge_dev_into_staging_template.md'} > .github/PULL_REQUEST_TEMPLATE/merge_dev_into_staging_template.md"
end

def typographie_component
  empty_directory 'app/components/typographie'
  run "curl -L #{REPO + '/template/app/components/typographie/typographie_component.rb'} > app/components/typographie/typographie_component.rb"
  run "curl -L #{REPO + '/template/app/components/typographie/typographie_component.html.erb'} > app/components/typographie/typographie_component.html.erb"
  run "curl -L #{REPO + '/template/spec/components/previews/typographie_component_preview.rb'} > spec/components/previews/typographie_component_preview.rb"
end

def flash_component
  empty_directory 'app/components/flash'
  run "curl -L #{REPO + '/template/app/components/flash/flash_component.rb'} > app/components/flash/flash_component.rb"
  run "curl -L #{REPO + '/template/app/components/flash/flash_component.html.erb'} > app/components/flash/flash_component.html.erb"
  run "curl -L #{REPO + '/template/app/components/flash/flash_component_controller.js'} > app/components/flash/flash_component_controller.js"

  empty_directory 'spec/components/flash'
  run "curl -L #{REPO + '/template/spec/components/flash/flash_component_spec.rb'} > spec/components/flash/flash_component_spec.rb"
  run "curl -L #{REPO + '/template/spec/components/previews/flash_component_preview.rb'} > spec/components/previews/flash_component_preview.rb"

  empty_directory 'app/views/shared'
  run "curl -L #{REPO + '/template/app/views/shared/_flashes.html.erb'} > app/views/shared/_flashes.html.erb"
end

def form_component
  empty_directory 'app/components/form'
  empty_directory 'app/components/form/input'
  run "curl -L #{REPO + '/template/app/components/form/input/input_component.rb'} > app/components/form/input/input_component.rb"
  run "curl -L #{REPO + '/template/app/components/form/input/input_component.html.erb'} > app/components/form/input/input_component.html.erb"
  empty_directory 'spec/components/previews/form'
  run "curl -L #{REPO + '/template/spec/components/previews/form/input_component_preview.rb'} > spec/components/previews/form/input_component_preview.rb"
end

def init_db
  rails_command "db:drop"
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end

def  init_git
  insert_into_file '.gitignore' do <<~GITIGNORE
    /tmp
    /log
    /coverage
  GITIGNORE
  end
  git init: %Q{ -b master }
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

after_bundle do
  # Stylesheets
  set_up_stylesheets
  set_up_assets

  # Linter
  install_rubocop
  config_rubocop
  
  # Testing
  install_rspec
  config_rspec
  install_capybara
  config_capybara
  install_factory_bot
  config_factory_bot
  install_shoulda_matchers
  config_shoulda_matchers
  install_database_cleaner
  config_database_cleaner
  install_simplecov
  config_simplecov
  install_faker

  # Security
  install_pundit
  pundit_config
  install_bundler_audit
  install_brakeman
  install_bullet
  config_bullet

  # Utilities
  install_sidekiq 
  config_sidekiq
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
  install_devise
  config_devise
  set_up_github_action
  set_up_github_PR_template

  # Admin
  install_active_admin
  config_active_admin

  # Helpers
  config_svg_helper

  # Components
  typographie_component
  flash_component
  form_component

  init_db
  run "rails stimulus:manifest:update"
  run "annotate"
  run "rubocop -A"
  init_git
end
