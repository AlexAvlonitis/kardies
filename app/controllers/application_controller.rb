class ApplicationController < ActionController::API
  include Pundit::Authorization
  before_action :doorkeeper_authorize!

  respond_to :json
  rescue_from Pundit::NotAuthorizedError, with: :user_forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def user_forbidden(exception)
    policy_name = exception.policy.class.to_s.underscore

    render_forbidden_json(
      I18n.t(
        "#{policy_name}.#{exception.query}",
        scope: 'pundit',
        default: :default
      )
    )
  end

  def record_not_found(_exception)
    render_forbidden_json(
      I18n.t('activerecord.errors.messages.record_not_found')
    )
  end

  def render_forbidden_json(error)
    render json: { errors: error }, status: :forbidden
  end
end
