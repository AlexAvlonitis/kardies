source 'https://rubygems.org'

gem 'mysql2'
gem 'puma'
gem 'rails'

gem 'active_model_serializers'
gem 'active_storage_validations'
gem 'acts_as_votable'
gem "aws-sdk-s3", require: false
gem 'devise'
gem 'doorkeeper', '~> 5.4'
gem 'kaminari'

# Elastic Search
gem 'elasticsearch', '~> 7'
gem 'elasticsearch-model', '~> 7'
gem 'elasticsearch-rails', '~> 7'

gem 'greek-cities'
gem 'httparty'
gem 'mailboxer'
gem 'mailgun_rails'
gem 'pundit'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'redis', '~> 4.0'
gem 'redis-rails'
gem 'validates_email_format_of'
gem 'stripe'

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-rails'
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
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
