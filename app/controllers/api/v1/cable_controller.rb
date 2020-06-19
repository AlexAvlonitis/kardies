module Api
  module V1
    class CableController < ApiController
      def unsubscribe
        ::OnlineStatusBroadcastJob.perform_later(current_user, false)

        render json: { message: 'ok' }, status: :ok
      end
    end
  end
end
