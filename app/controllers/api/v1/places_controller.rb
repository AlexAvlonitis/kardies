module Api
  module V1
    class PlacesController < ApiController
      skip_before_action :doorkeeper_authorize!

      def states
        @states ||= ::GC.states
        render json: @states, status: :ok
      end

      def cities
        @cities ||= ::GC.cities(place_params.values.first).to_json
        render json: @cities, status: :ok
      end

      private

      def place_params
        params.permit(:state)
      end
    end
  end
end
