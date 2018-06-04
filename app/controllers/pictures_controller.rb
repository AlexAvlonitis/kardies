class PicturesController < ApplicationController
  def destroy
    picture = current_user.gallery.pictures.find(params[:id])
    begin
      picture.destroy
      render json: { status: 'success' }, status: :ok
    rescue StandardError => e
      render json: { errors: e }, status: :unprocessable_entity
    end
  end
end
