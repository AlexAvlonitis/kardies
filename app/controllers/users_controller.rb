class UsersController < ApplicationController

  before_action :set_user, except: [:index]

  def index
    if current_user.search_criteria.present?
      @users = User.search(current_user.search_criteria.last).page params[:page]
      @search ||= current_user.search_criteria.last
    else
      @users = User.all_except(current_user)
                   .includes(:user_detail)
                   .not_blocked
                   .order(created_at: :desc)
                   .page params[:page]
      @search ||= SearchCriterium.new
    end
  end

  def show
    user_deleted_check
  end

  private

  def set_user
    @user = User.find_by_username(params[:username])
    rescue_error unless @user
  end
end
