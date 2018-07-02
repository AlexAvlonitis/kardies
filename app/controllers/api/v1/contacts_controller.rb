module Api
  module V1
    class ContactsController < ApiController
      def index
        redirect_to root_path if user_signed_in?
        @contact = Contact.new
        @user = User.new unless user_signed_in?
      end

      def create
        @contact = Contact.new contact_params
        @user = User.new unless user_signed_in?

        if @contact.save
          flash[:success] = t '.contact_sent'
          redirect_to root_path
        else
          render :index
        end
      end

      private

      def contact_params
        params.require(:contact).permit(:name, :email, :subject, :description)
      end
    end
  end
end
