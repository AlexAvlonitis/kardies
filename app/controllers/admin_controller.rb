class AdminController < ApplicationController
  before_action :authorize_admin!

  private

  def authorize_admin!
    authenticate_user!
    return if current_user.admin?
    redirect_to root_path, alert: 'You are not authorized to access this page'
  end
end
