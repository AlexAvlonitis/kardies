class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

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
    else
      flash[:error] = @contact.errors.full_messages[0]
    end
    redirect_to contacts_path
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :description)
  end
end
