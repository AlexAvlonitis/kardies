module Api
  module V1
    class AboutsController < ApiController
      before_action :set_about, only: :update

      def update
        if @about.update(about_params)
          render json: current_user, status: :ok
        else
          render json: @about.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def about_params
        params.require(:about).permit(allow_params)
      end

      def allow_params
        %i[job hobby relationship_status looking_for description]
      end

      def set_about
        @about = current_user.about || current_user.build_about
      end
    end
  end
end
