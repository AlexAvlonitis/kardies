module Api
  module V1
    class RegistrationsController < ::Devise::RegistrationsController
      skip_before_action :doorkeeper_authorize!
      before_action :set_user_about,
                    :set_user_email_preferences,
                    :set_user_blocked_users,
                    only: %i[edit update]

      def create
        join_username
        super
      end

      private

      def sign_up_params
        params.permit(allow_params)
      end

      def join_username
        params[:username] = params[:username].split(' ').join('_')
      end

      def update_resource(resource, params)
        resource.update_without_password(params)
      end

      def account_update_params
        params.require(:user).permit(allow_params)
      end

      def allow_params
        [
          :username, :email, :password, :password_confirmation,
          user_detail_attributes: %i[
            id state gender age profile_picture
          ]
        ]
      end

      def set_user_about
        @about = current_user.about || current_user.build_about
      end

      def set_user_email_preferences
        @email_preferences =
          current_user.email_preference || current_user.build_email_preference
      end

      def set_user_blocked_users
        @blocked_user_ids ||= current_user.blocked_users.map(&:blocked_user_id)

        @blocked_users ||= User.find(@blocked_user_ids)
      end
    end
  end
end
