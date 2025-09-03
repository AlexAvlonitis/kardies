require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_cable/engine'
require 'active_storage/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kardies
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.api_only = true
    config.i18n.default_locale = :el
    config.autoload_paths += %W(#{config.root}/lib)

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # Allow requests from the frontend domain
        origins 'localhost:3000', 'localhost:3001', 'localhost:3002', '127.0.0.1:3000', '127.0.0.1:3001', '127.0.0.1:3002'

        resource(
          '*',
          headers: :any,
          methods: [:get, :post, :delete, :put, :patch, :options, :head],
          credentials: true,
          expose: ['Authorization']
        )
      end
    end

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use Rack::Attack
  end
end
