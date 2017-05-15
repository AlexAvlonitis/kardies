source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Mysql
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'simple_form'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'kaminari'
gem 'redis-rails'
gem "haml-rails", "~> 0.9"
gem 'devise'
gem 'omniauth-facebook'
gem "paperclip", "~> 5.0.0"
gem "pundit"
gem 'bootstrap', '~> 4.0.0.alpha6'
gem "font-awesome-rails"
gem 'acts_as_votable', '~> 0.10.0'
gem 'greek-cities', '~> 1.0.1'
gem 'chewy'
gem 'aws-sdk', '~> 2.3.0'
gem 'mailboxer'
gem 'jquery-ui-rails'
gem 'pry-rails'
gem "lazyload-rails"

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-nginx'
  gem 'capistrano3-puma'
  gem 'capistrano-rails'
  gem 'capistrano-rails-db'
  gem 'capistrano-rails-console'
  gem 'capistrano-upload-config'
  gem 'sshkit-sudo'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
