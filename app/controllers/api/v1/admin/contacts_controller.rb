module Api
  module V1
    module Admin
      class ContactsController < AdminController
        def index
          @contacts = Contact.all
        end
      end
    end
  end
end
