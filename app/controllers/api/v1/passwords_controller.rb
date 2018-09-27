module Api
  module V1
    class PasswordsController < ::Devise::RegistrationsController
      skip_before_action :authenticate_scope!
      skip_before_action :doorkeeper_authorize!, only: :create

      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)

        unless successfully_sent?(resource)
          logger.error(reset_password: resource.errors.full_messages)
        end
        render json: { message: I18n.t('users.show.password_sent') }, status: :ok
      end

      private

      def resource_params
        params.permit(:email, :password, :format)
      end
    end
  end
end
