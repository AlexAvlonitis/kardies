module Api
  module V1
    class ApiController < ApplicationController
      def me
        respond_with current_resource_owner
      end

      def current_user
        @current_user ||= current_resource_owner
      end

      def block_and_render(error)
        render json: { errors: error }, status: :unauthorized
      end

      private

      def current_resource_owner
        ::User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
