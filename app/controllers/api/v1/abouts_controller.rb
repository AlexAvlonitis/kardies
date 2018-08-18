module Api
  module V1
    class AboutsController < ApiController
      def update
        @about = current_user.about
        save_about
      end

      private

      def about_params
        params.require(:about).permit(allow_params)
      end

      def allow_params
        %i[job hobby relationship_status looking_for description]
      end

      def save_about
        if @about.update(about_params)
          render json: current_user, status: :ok
        else
          render json: @about.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end
end
