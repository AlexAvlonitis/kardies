module Notifications
  class Hearts < Base
    def initialize(user, mailer_klass = nil)
      super(user)
      @mailer_klass = mailer_klass || HeartsMailer
    end

    def execute
      return unless likes_email_allowed? && user_not_online
      mailer_klass.new_hearts_notification(user).deliver_later
    end

    private

    attr_reader :mailer_klass

    def likes_email_allowed?
      if user.email_preference.present?
        user.email_preference.likes
      else
        true
      end
    end

    def user_not_online
      user.is_signed_in ? false : true
    end
  end
end
