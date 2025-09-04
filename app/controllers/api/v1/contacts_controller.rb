module Api
  module V1
    class ContactsController < ApiController
      skip_before_action :doorkeeper_authorize!, only: :create

      def create
        @contact = ::Contact.new(contact_params)

        if @contact.save
          render json: { message: 'Ευχαριστούμε!' }, status: :ok
        else
          render json: { errors: I18n.t('contacts.index.errors') }, status: :unprocessable_entity
        end
      end

      private

      def contact_params
        params.require(:contact)
              .permit(:name, :email, :subject, :description)
      end
    end
  end
end
