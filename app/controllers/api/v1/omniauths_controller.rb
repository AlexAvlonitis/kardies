module Api
  module V1
    class OmniauthsController < ApiController
      skip_before_action :doorkeeper_authorize!

      def facebook
        @user = User.from_omniauth(omniauth_params)

        if @user.persisted?
          user = Doorkeeper::AccessToken.create!(
            resource_owner_id: @user.id,
            expires_in: 1.day
          )
          render json: user_token(user).as_json, status: :ok
        else
          render json: @user.errors.full_messages, status: :forbidden
        end
      end

      private

      def omniauth_params
        params_hash =  {}
        params_hash.merge!({name: params['name']})
        params_hash.merge!({email: params['email']})
        params_hash.merge!({userID: params['userID']})
        params_hash.merge!({picture: params['picture']})
        params_hash
      end

      def user_token(user)
        {
          access_token: user.token,
          type: 'bearer',
          expires_in: user.expires_in,
          created_at: user.created_at
        }
      end
    end
  end
end
