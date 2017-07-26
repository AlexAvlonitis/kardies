module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all.order(created_at: :desc).page params[:page]
      @user_count = User.all.count
    end

    def admin_destroy
      user = User.find_by(username: params[:username])
      user.soft_delete
      flash['success'] = 'User has been blocked'
      redirect_to admin_users_path
    end

    def admin_unblock
      user = User.find_by(username: params[:username])
      user.update(deleted_at: nil)
      flash['success'] = 'User has been unblocked'
      redirect_to admin_users_path
    end

    def create_admin
      user = User.find_by(username: params[:username])
      user.update(admin: true)
      flash['success'] = "#{user.username} is admin"
      redirect_to admin_users_path
    end

    def undo_admin
      user = User.find_by(username: params[:username])
      user.update(admin: false)
      flash['success'] = "#{user.username} is not an admin"
      redirect_to admin_users_path
    end
  end
end
