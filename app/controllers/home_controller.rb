class HomeController < ApplicationController
  def index
    @place = current_user.places.build
  end
end
