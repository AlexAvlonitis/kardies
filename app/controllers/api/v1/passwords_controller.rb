module Api
  module V1
    class PasswordsController < ::Devise::RegistrationsController
      skip_before_action :authenticate_scope!
      skip_before_action :doorkeeper_authorize!, only: %i[create update]

      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)

        unless successfully_sent?(resource)
          logger.error(reset_password: resource.errors.full_messages)
        end
        render json: { message: I18n.t('users.show.password_sent') }, status: :ok
      end

      def update
        self.resource = resource_class.reset_password_by_token(resource_params)

        if resource.errors.empty?
          render json: { message: I18n.t('users.show.password_changed') }, status: :ok
        else
          set_minimum_password_length
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def resource_params
        params.permit(
          :email,
          :password,
          :password_confirmation,
          :format,
          :reset_password_token
        )
      end
    end
  end
end
