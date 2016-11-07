class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @contact = Contact.new
  end

  def create
    @contact = Contact.new contact_params

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
