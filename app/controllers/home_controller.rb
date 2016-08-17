class HomeController < ApplicationController
  def index
    @place = current_user.places.build
    @post  = current_user.posts.build
  end
end
