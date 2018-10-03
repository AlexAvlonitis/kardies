module Notifications
  class Conversations < Base
    def initialize(user, mailer_klass = nil)
      super(user)
      @mailer_klass = mailer_klass || ConversationMailer
    end

    def execute
      return if user.is_signed_in?
      mailer_klass.message_notification(user).deliver_later if email_allowed?
    end

    private

    attr_reader :mailer_klass

    def email_allowed?
      user.email_preference.present? user.email_preference.messages : true
    end
  end
end
