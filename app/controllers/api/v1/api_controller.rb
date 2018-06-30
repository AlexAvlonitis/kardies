module Api
  module V1
    class ApiController < ApplicationController
      def me
        respond_with current_resource_owner
      end

      def block_and_render(error)
        e = error
        render json: { errors: e }, status: :unauthorized
      end
    end
  end
end
