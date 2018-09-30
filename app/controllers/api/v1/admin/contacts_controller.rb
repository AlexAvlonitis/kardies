module Admin
  class ContactsController < AdminController
    def index
      @contacts = Contact.all
    end
  end
end
