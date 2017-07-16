class Admin::UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :desc).page params[:page]
    @user_count = User.all.count
  end
end
