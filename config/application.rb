require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Travelhub
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.api_only = true
    config.i18n.default_locale = :el
    config.autoload_paths += %W(#{config.root}/lib)

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3000', '127.0.0.1:3000'
        resource(
          '*',
          headers: :any,
          methods: [:get, :post, :delete, :put, :patch, :options, :head]
        )
      end
    end
    config.middleware.use Rack::Attack
  end
end
