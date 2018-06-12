module Api
  module V1
    class PlacesController < ApiController
      def states
        @states ||= GC.states
        render json: @states, status: :ok
      end

      def cities
        @cities ||= GC.cities(params[:state]).to_json
        render json: @cities, status: :ok
      end

      private

      def place_params
        params.require(:place).permit(:state)
      end
    end
  end
end
