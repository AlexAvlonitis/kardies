module Api
  module V1
    class GalleriesController < ApiController
      def update
        save_gallery
      end

      private

      def gallery_params
        params.require(:gallery).permit(:picture)
      end

      def save_gallery
        if params[:picture].try(:empty?)
          render json: { errors: 'Χρειάζεται φωτογραφία' }, status: :unprocessable_entity
          return
        end

        Gallery.create(user: current_user) unless current_user.gallery

        if pic = current_user.gallery.pictures.create(picture: params[:picture])
          render json: current_user, status: :ok
        else
          render json: pic.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end
end
