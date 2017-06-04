class ConversationsNotificationEmail

  def initialize(user)
    @user = user
  end

  def send_email
    if messages_email_allowed? && user_not_online
      ConversationMailer.message_notification(user).deliver_later
    else
      nil
    end
  end

  private
  attr_reader :user

  def messages_email_allowed?
    user.email_preference.present? ? !!(user.email_preference.messages) : true
  end

  def user_not_online
    if user.is_signed_in
      false
    elsif user.is_signed_in == false
      true
    end
  end
end
