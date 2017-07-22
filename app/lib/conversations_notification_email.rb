class ConversationsNotificationEmail
  def initialize(user)
    @user = user
  end

  def send_email
    if user.is_signed_in?
      nil
    elsif email_allowed?
      ConversationMailer.message_notification(user).deliver_later
    end
  end

  private

  attr_reader :user

  def email_allowed?
    if user.email_preference.present?
      user.email_preference.messages
    else
      true
    end
  end
end
