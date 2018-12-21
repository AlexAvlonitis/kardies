module Api
  module V1
    class EmailPreferencesController < ApiController
      before_action :set_email_preferences, only: :update

      def update
        if @email_preferences.update(email_preferences_params)
          render json: current_user, status: :ok
        else
          render json: @email_preferences.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def set_email_preferences
        @email_preferences = current_user.email_preference ||
                             current_user.build_email_preference
      end

      def email_preferences_params
        params.require(:email_preference).permit(allow_params)
      end

      def allow_params
        %i[likes messages news]
      end
    end
  end
end
