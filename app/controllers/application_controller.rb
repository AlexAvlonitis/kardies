class ApplicationController < ActionController::Base
  include Pundit
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
    cookies.signed['user_id'] = user.id
  end

  def rescue_error
    flash[:alert] = 'The user you were looking for could not be found'
    redirect_to users_path
  end

  def block_and_redirect
    flash[:error] = t 'users.show.blocked_user'
    redirect_to users_path
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end
end
