class Admin::ContactsController < Admin::ApplicationController
  def index
    @contacts = Contact.all
  end
end
