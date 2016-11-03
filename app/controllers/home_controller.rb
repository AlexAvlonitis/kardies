class HomeController < ApplicationController
  def index
    redirect_to user_path current_user
  end
end
