module Api
  module V1
    class PicturesController < ApiController
      def destroy
        picture = current_user.gallery.pictures.find_by(id: params[:id])

        if picture
          picture.destroy
          render json: current_user, status: :ok
        else
          render json: { errors: 'Η φωτογραφία δεν υπάρχει' }, status: :unprocessable_entity
        end
      end

      private

      def picture_params
        params.permit(:id)
      end
    end
  end
end
