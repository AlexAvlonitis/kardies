class PlacesController < ApplicationController


  def cities
    render json: GC.cities(params[:state]).to_json
  end

  private

  def place_params
    params.require(:place).permit(:state)
  end
end
