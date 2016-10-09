class UsersController < ApplicationController

  before_action :set_user, except: [:index]

  def index
    if search_params.present?
      @users = User.search(search_params)
    else
      @users = User.all_except(current_user).order(is_signed_in: :desc)
    end
  end

  def show
  end

  def like
    @user.liked_by current_user
    redirect_to users_path
  end

  def unlike
    @user.unliked_by current_user
    redirect_to users_path
  end

  def my_likes
    unless params[:username] == current_user.username
      flash[:error] = "You are not allowed to view this page"
      redirect_to users_path
    end
    @likes = current_user.votes_for.voters
  end

  private

  def search_params
    all_params = []
    all_params << params[:state] if params[:state] && !params[:state].blank?
    all_params << params[:city] if params[:city] && !params[:city].blank?
    all_params << params[:online] if params[:online]
    all_params
  end

  def set_user
    @user = User.find_by_username(params[:username])
    rescue_error unless @user
  end

  def rescue_error
    flash[:alert] = 'The user you were looking for could not be found'
    redirect_to users_path
  end
end
