module Api
  module V1
    class ConfirmationsController < ::Devise::RegistrationsController
      skip_before_action :authenticate_scope!
      skip_before_action :doorkeeper_authorize!, only: :show

      def show
        self.resource = User.confirm_by_token(params[:confirmation_token])

        if resource.errors.empty?
          render(
            json: { message: I18n.t('devise.confirmations.confirmed') },
            status: :ok
          )
        else
          render(
            json: {
              errors: I18n.t(
                'devise.failure.invalid',
                authentication_keys: 'token'
              )
            },
            status: :unprocessable_entity
          )
        end
      end
    end
  end
end
