class PlacesController < ApplicationController

  def index
  end

  def create
    @place = current_user.places.build(place_params)

    if @place.save
      flash[:notice] = "Place has been saved"
      redirect_to root_path
    else
      flash[:notice] = "Place has not been saved"
      @users = User.all
      render 'home/index'
    end

  end

  def states
    render json: CS.states(params[:country]).to_json
  end

  def cities
    render json: CS.cities(params[:state]).to_json
  end

  private

  def place_params
    params.require(:place).permit(:country, :state, :city, :visit_date)
  end
end
