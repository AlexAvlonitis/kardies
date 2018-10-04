class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include Pundit
  before_action :doorkeeper_authorize!

  respond_to :json
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    block_and_render(
      I18n.t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
    )
  end
end
