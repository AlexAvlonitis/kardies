source 'https://rubygems.org'

gem 'mysql2'
gem 'puma'
gem 'rails', '~> 5.2'

gem 'active_model_serializers'
gem 'acts_as_votable', '~> 0.10.0'
gem 'aws-sdk-s3', '~> 1'
gem 'devise'
gem 'doorkeeper', '~> 5'
gem 'kaminari'

# Elastic Search
gem 'elasticsearch', '~> 6'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'greek-cities'
gem 'httparty'
gem 'mailboxer'
gem 'mailgun_rails'
gem 'paperclip', '~> 6.0'
gem 'pry-rails'
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'redis', '~> 4.0'
gem 'redis-rails'
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
  gem 'shoulda-matchers'
  gem 'webmock'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-nginx'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console'
  gem 'capistrano-rails-db'
  gem 'capistrano-rbenv'
  gem 'capistrano-upload-config'
  gem 'capistrano3-puma'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'sshkit-sudo'
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
