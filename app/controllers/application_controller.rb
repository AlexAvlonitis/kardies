class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token
  before_action :doorkeeper_authorize!
  respond_to :json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= current_resource_owner
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
