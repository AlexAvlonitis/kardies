class UsersController < ApplicationController

  before_action :set_user, except: [:index]

  def index
    @users = User.where.not(id: current_user.id)
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

  private

  def set_user
    @user = User.find_by_username(params[:username])
    rescue_error unless @user
  end

  def rescue_error
    flash[:alert] = 'The user you were looking for could not be found'
    redirect_to users_path
  end
end
