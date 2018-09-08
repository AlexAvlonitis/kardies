class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  before_action :doorkeeper_authorize!

  respond_to :json
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
end
