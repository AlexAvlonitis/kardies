class ApplicationController < ActionController::Base
  include Pundit
  before_action :set_locale
  before_action :authenticate_user!, except: [:cities]
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound do
    flash[:alert] = 'Resource not found.'
    redirect_back_or root_path
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  def set_cookie(user = nil)
    cookies.signed["user_id"] = user.id
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(option= {})
    {locale: I18n.locale}
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
