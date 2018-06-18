module Api
  module V1
    class ApiController < ApplicationController
      before_action :authenticate_user!
      skip_before_action :verify_authenticity_token

      def block_and_render(error)
        e = error
        render json: { errors: e }, status: :unauthorized
      end
    end
  end
end
