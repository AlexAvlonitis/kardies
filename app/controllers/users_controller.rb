class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])

    rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The user you were looking for could not be found'
    redirect_to users_path
  end
end
