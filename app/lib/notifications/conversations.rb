module Notifications
  class Conversations < Base
    def initialize(user, mailer_klass = nil)
      super(user)
      @mailer_klass = mailer_klass || ConversationMailer
    end

    def execute
      return if user.is_signed_in? && email_allowed?
      mailer_klass.message_notification(user).deliver_later
    end

    private

    attr_reader :mailer_klass

    def email_allowed?
      user.email_preference.present? ? user.email_preference.messages : true
    end
  end
end
