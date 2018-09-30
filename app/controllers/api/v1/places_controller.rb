module Api
  module V1
    class PlacesController < ApiController
      skip_before_action :doorkeeper_authorize!

      def states
        @states ||= ::GC.states
        render json: @states, status: :ok
      end
    end
  end
end
