module Api
  module V1
    class ContactsController < ApiController
      def create
        @contact = ::Contact.new contact_params

        if @contact.save
          flash[:success] = t '.contact_sent'
          redirect_to root_path
        else
          render :index
        end
      end

      private

      def contact_params
        params.permit(:name, :email, :subject, :description)
      end
    end
  end
end
