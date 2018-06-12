class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
    return block_and_redirect if UserBlockedCheck.call(current_user, @user)
    only_if_profile_pic_exists
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
    rescue_error unless @user
  end

  def only_if_profile_pic_exists
    return if @user == current_user
    unless current_user.profile_picture_exists?
      redirect_to users_path
      flash[:error] = t '.profile_pic_needed'
    end
  end
end
