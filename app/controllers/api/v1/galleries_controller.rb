module Api
  module V1
    class GalleriesController < ApiController
      def update
        if gallery_params[:picture].blank?
          render json: { errors: 'Χρειάζεται φωτογραφία' }, status: :unprocessable_entity
          return
        end

        Gallery.create(user: current_user) unless current_user.gallery

        if pic = current_user.gallery.pictures.create(gallery_params)
          render json: current_user, status: :ok
        else
          render json: pic.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def gallery_params
        params.require(:gallery).permit(:picture)
      end
    end
  end
end
