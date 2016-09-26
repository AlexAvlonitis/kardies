class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def show
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
