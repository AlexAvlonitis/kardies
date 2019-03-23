class ApplicationController < ActionController::API
  include Pundit
  before_action :doorkeeper_authorize!

  respond_to :json
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    block_and_render(
      I18n.t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
    )
  end

  def record_not_found(_exception)
    block_and_render(
      I18n.t('activerecord.errors.messages.record_not_found')
    )
  end
end
