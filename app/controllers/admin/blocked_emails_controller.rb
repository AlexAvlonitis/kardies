module Admin
  class BlockedEmailsController < AdminController
    def index
      @blocked_emails ||= BlockedEmails.all
    end
  end
end
