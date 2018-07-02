module Api
  module V1
    class ApiController < ApplicationController
      before_action :doorkeeper_authorize!

      def me
        respond_with current_resource_owner
      end

      def current_user
        @current_user ||= current_resource_owner
      end

      def block_and_render(error)
        e = error
        render json: { errors: e }, status: :unauthorized
      end

      private

      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
