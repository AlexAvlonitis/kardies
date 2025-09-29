module Api
  module V1
    class ApiController < ApplicationController
      def me
        render json: current_user, status: :ok, serializer: UserFullSerializer
      end

      def current_user
        return unless doorkeeper_token

        @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
      end
    end
  end
end
