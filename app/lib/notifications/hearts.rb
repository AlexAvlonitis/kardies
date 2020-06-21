module Notifications
  class Hearts < Base
    def initialize(user, mailer_klass = nil)
      super(user)
      @mailer_klass = mailer_klass || HeartsMailer
    end

    def execute
      return if !likes_notifications_allowed? && user_online?

      mailer_klass.new_hearts_notification(user).deliver_later
    end

    private

    attr_reader :mailer_klass

    def likes_notifications_allowed?
      return user.email_preference.likes if user.email_preference

      true
    end

    def user_online?
      user.is_signed_in
    end
  end
end
