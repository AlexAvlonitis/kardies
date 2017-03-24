class Admin::UsersController < ApplicationController
  def index
    @users = User.all.page params[:page]
    @user_count = User.all.count
  end
end
