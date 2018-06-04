class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    @users ||= search_present? ? get_all_indexed_users : get_all_users
    @search ||= search_criteria
  end

  def show
    only_if_profile_pic_exists
    only_if_not_blocked
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
    User.get_all.except_user(current_user).confirmed.page(params[:page])
  end

  def get_all_indexed_users
    User.search(last_search, current_user).page(params[:page]).objects
  end

  def last_search
    current_user.search_criteria.last
  end

  def only_if_profile_pic_exists
    return if @user == current_user
    unless current_user.profile_picture_exists?
      redirect_to users_path
      flash[:error] = t '.profile_pic_needed'
    end
  end

  def only_if_not_blocked
    user_blocked = UserBlockedCheck.call(current_user, @user)
    if user_blocked
      redirect_to users_path
      flash[:error] = t '.blocked_user'
    end
  end
end
