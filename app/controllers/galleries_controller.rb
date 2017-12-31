class GalleriesController < ApplicationController
  def update
    save_gallery
  end

  private

  def gallery_params
    params.require(:gallery).permit(:picture)
  end

  def save_gallery
    unless params[:picture]
      render json: { errors: 'picture required' }, status: 402
      return
    end

    unless current_user.gallery
      Gallery.create(user: current_user)
    end

    begin
      pic = current_user.gallery.pictures.create(picture: params[:picture])
      render json: { "url": pic.picture.url }, status: 200
    rescue => e
      render json: { errors: e + 'hhhey' }, status: 402
    end
  end
end
