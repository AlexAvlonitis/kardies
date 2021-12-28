module Api
  module V1
    class OmniauthsController < ApiController
      skip_before_action :doorkeeper_authorize!

      def facebook
        user = Users::CreateFacebookUserService.call(params)

        if user.persisted?
          access_token = Doorkeeper::AccessToken.create!(
            resource_owner_id: user.id,
            expires_in: 1.day
          )
          render json: user_token(access_token).as_json, status: :ok
        else
          render json: user.errors.full_messages, status: :forbidden
        end
      end

      private

      def user_token(access_token)
        {
          access_token: access_token.token,
          type: 'bearer',
          expires_in: access_token.expires_in,
          created_at: access_token.created_at
        }
      end
    end
  end
end
