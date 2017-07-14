class ConversationsNotificationEmail
  def initialize(user)
    @user = user
  end

  def send_email
    if user.is_signed_in || email_has_been_sent
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

  def email_has_been_sent
    user.conversation_notifications.present?
  end
end
