ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'spec_helper'
require 'shoulda-matchers'
require 'database_cleaner'
require 'webmock/rspec'
require 'climate_control'

WebMock.disable_net_connect!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller

  config.extend ControllerMacros, type: :controller

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec

      with.library :active_record

      with.library :rails
    end
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:each) { stub_request(:any, //).to_return({}) }
end
