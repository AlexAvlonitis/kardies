module Api
  module V1
    class ApiController < ApplicationController
      def me
        respond_with current_user
      end

      def current_user
        return unless doorkeeper_token

        @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
      end
    end
  end
end
