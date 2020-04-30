module Api
  module V1
    class GoldenUsersController < ApiController

      def index
        render json: golden_users, status: :ok
      end

      private

      def golden_users
        @golden_users ||= User.joins(:membership, :user_detail)
      end
    end
  end
end
