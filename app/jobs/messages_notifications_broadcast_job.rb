class MessagesNotificationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation, current_user)
    recipient = conversation.participants.reject { |user| user == current_user }.first
    return unless recipient

    add_conversation_notification(conversation, recipient)
    send_email(recipient)
  end

  def add_conversation_notification(conversation, recipient)
    ::ActionCable.server.broadcast(
      "messages_notifications_#{recipient.username}",
      { conversation_id: conversation.id }
    )
  end

  def send_email(recipient)
    return unless user_decorator(recipient).message_email_notification_allowed?

    ::ConversationMailer.message_notification(recipient).deliver_later
  end

  def user_decorator(user)
    @user_decorator ||= UserDecorator.new(user)
  end
end
