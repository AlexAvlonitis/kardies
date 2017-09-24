class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    @users ||= search_present? ? get_all_indexed_users : get_all_users
    @search ||= search_criteria
  end

  def show
    user_deleted_check
    show_only_if_profile_pic_exists
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
    rescue_error unless @user
  end

  def search_criteria
    search_present? ? last_search : SearchCriterium.new
  end

  def search_present?
    current_user.search_criteria.present?
  end

  def get_all_users
    User.all_except(current_user)
        .includes(:user_detail)
        .not_blocked
        .order(created_at: :desc)
        .page params[:page]
  end

  def get_all_indexed_users
    User.search(last_search).page params[:page]
  end

  def last_search
    current_user.search_criteria.last
  end

  def show_only_if_profile_pic_exists
    return if @user == current_user
    unless current_user.profile_picture_exists?
      redirect_to users_path
      flash[:error] = t '.profile_pic_needed'
    end
  end
end
