source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
gem 'mysql2'
gem 'puma', '~> 3.0'

gem 'active_model_serializers'
gem 'acts_as_votable', '~> 0.10.0'
gem 'aws-sdk-s3', '~> 1'
gem 'chewy'
gem 'devise'
gem 'doorkeeper'
gem 'greek-cities'
gem 'kaminari'
gem 'mailboxer'
gem 'mailgun_rails'
gem 'omniauth-facebook'
gem 'paperclip', '~> 6.0'
gem 'pry-rails'
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'redis', '~> 3.3'
gem 'redis-rails'
gem 'sitemap_generator'
gem 'validates_email_format_of'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'capistrano'
  gem 'capistrano-nginx'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console'
  gem 'capistrano-rails-db'
  gem 'capistrano-rbenv'
  gem 'capistrano-upload-config'
  gem 'capistrano3-puma'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'sshkit-sudo'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
