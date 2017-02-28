source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'mysql2', '~> 0.3.20'

gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# search
gem 'ransack'
gem "kaminari"

# register
gem 'devise'
gem 'omniauth-facebook'
gem 'settingslogic' #管理我們的秘密key
gem 'omniauth-google-oauth2'

# front tools
gem 'nested_form'
gem 'font-awesome-rails'
gem 'less-rails-semantic_ui'
gem 'autoprefixer-rails'
gem 'therubyracer'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sprockets', '3.6.3'

# image tools
gem "paperclip", "~> 4.3"

# google map
gem 'gmaps4rails'
gem 'geocoder'
gem 'faker'

# braintree
gem "braintree", "~> 2.69.1"

# Admin
gem 'rails_admin', '~> 1.0'

# cron job
gem 'whenever', :require => false


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # deploy
  gem 'capistrano'
	gem 'capistrano-rails'
	gem 'capistrano3-puma'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler', '~> 1.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
