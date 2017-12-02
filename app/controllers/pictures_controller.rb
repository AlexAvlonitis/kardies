class PicturesController < ApplicationController
  def destroy
    picture = current_user.gallery.pictures.find(params[:id])
    begin
      picture.destroy
      render json: { status: "success" }, status: 200
    rescue => e
      render json: { errors: e }, status: 402
    end
  end
end
