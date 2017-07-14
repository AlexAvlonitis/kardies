class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to user_path(current_user) if user_signed_in?
    @user = User.new
    @user.build_user_detail
  end
end
