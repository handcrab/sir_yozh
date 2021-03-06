source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'figaro'
gem 'rails-i18n'
# gem 'russian'

gem 'slim-rails'
gem 'materialize-sass'

gem 'mechanize'
gem 'hirb', group: :development
gem 'devise'
gem 'devise-i18n-views'

gem 'acts-as-taggable-on', '~> 3.4'

gem 'puma'
gem 'newrelic_rpm'

gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons'
gem 'foreman'
gem 'clockwork'

group :development, :test do
  # Call 'byebug' to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'

  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'shoulda-matchers'
  # gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'

  gem 'guard-rspec' # guard :rspec, cmd:"spring rspec"
  # gem 'guard-cucumber' # guard init cucumber

  gem 'spring-commands-rspec' 
  # bundle exec spring binstub rspec
  # spring stop

  gem 'bullet' # n+1
  # gem 'lol_dba' # rake db:find_indexes
  gem 'rack-mini-profiler'
  # gem 'flamegraph' # ?pp=flamegraph
  # gem 'meta_request' # rails panel
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'timecop'
end
