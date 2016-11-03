class GalleriesController < ApplicationController

  def index
    @galleries = current_user.galleries.all
    @gallery = Gallery.new
  end

  def create
    gallery = current_user.galleries.build(gallery_params)

    if gallery.save
      if params[:pictures]
        params[:pictures].each do |picture|
          gallery.pictures.create(picture: picture)
        end
      end
      redirect_to galleries_path
    else
      flash.now[:alert] = 'error did not save gallery'
      redirect_to galleries_path
    end
  end

  def destroy
    Gallery.find_by_id(params[:id]).destroy
    flash[:success] = t '.gallery_deleted'
    redirect_to galleries_path
  end

  private

  def gallery_params
    params.require(:gallery).permit(allow_params)
  end

  def allow_params
    [:name, :description, :pictures]
  end
end
