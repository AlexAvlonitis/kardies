class HomeController < ApplicationController
  def index
    @place = current_user.places.build
    @users = User.all
  end
end
