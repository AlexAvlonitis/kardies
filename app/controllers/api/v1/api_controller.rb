module Api
  module V1
    class ApiController < ApplicationController
      def block_and_render(error)
        e = error
        render json: { errors: e }, status: :unauthorized
      end
    end
  end
end
