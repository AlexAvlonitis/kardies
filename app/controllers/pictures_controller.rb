class PicturesController < ApplicationController
  def update
    current_user.gallery || current_user.build_gallery
    save_gallery
  end

  def destroy
    current_user.gallery.destroy
    flash[:success] = t '.gallery_deleted'
    redirect_to galleries_path
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

    if @gallery.update(gallery_params)
      @gallery.pictures.create(picture: params[:picture])
      render json: 'success', status: 200
    else
      render json: { errors: e + 'hhhey' }, status: 402
    end
  end
end
