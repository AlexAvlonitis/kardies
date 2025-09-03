module Api
  module V1
    class GalleriesController < ApiController
      def update
        Rails.logger.info "GalleriesController#update called with params: #{params.inspect}"
        Rails.logger.info "Headers: #{request.headers.env.select { |k, _| k.start_with?('HTTP_') }.inspect}"

        # Log raw request details
        Rails.logger.info "Raw request body size: #{request.body.size} bytes"

        # Try different parameter access approaches
        picture_param = params.dig(:gallery, :picture)
        if picture_param.blank?
          Rails.logger.warn "Picture parameter is blank"
          render json: { errors: 'Χρειάζεται φωτογραφία' }, status: :unprocessable_entity
          return
        end

        Rails.logger.info "Picture param info: #{picture_param.inspect}"

        # Create gallery if needed
        Gallery.create(user: current_user) unless current_user.gallery

        begin
          picture = current_user.gallery.pictures.new

          # Attach the picture
          Rails.logger.info "Attaching picture to the record"
          picture.picture.attach(params[:gallery][:picture])

          if picture.save
            Rails.logger.info "Picture saved successfully"
            render json: current_user, status: :ok
          else
            Rails.logger.error "Picture save failed with errors: #{picture.errors.full_messages}"
            render json: picture.errors.full_messages, status: :unprocessable_entity
          end
        rescue => e
          Rails.logger.error "Error in gallery update: #{e.class} - #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
          render json: { errors: "Σφάλμα: #{e.message}" }, status: :unprocessable_entity
        end
      end

      private

      def gallery_params
        params.require(:gallery).permit(:picture)
      end
    end
  end
end
