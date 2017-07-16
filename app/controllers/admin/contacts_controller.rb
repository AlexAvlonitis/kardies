module Admin
  class ContactsController < Admin::ApplicationController
    def index
      @contacts = Contact.all
    end
  end
end
