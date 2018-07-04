module Api
  module V1
    class AboutsController < ApiController
      def update
        @about = current_user.build_about
        save_about
      end

      private

      def about_params
        params.permit(allow_params)
      end

      def allow_params
        %i[job hobby relationship_status looking_for description]
      end

      def save_about
        if @about.update(about_params)
          render json: @about, status: :ok
        else
          render json: { errors: @about.errors }, status: :internal_server_error
        end
      end
    end
  end
end
