class MessagesNotificationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation, current_user)
    recipient = conversation.participants.reject { |user| user == current_user }.first

    add_conversation_notification(conversation, recipient)
    send_email(conversation, recipient)
  end

  def add_conversation_notification(conversation, recipient)
    return unless recipient

    ::ActionCable.server.broadcast(
      "messages_notifications_#{recipient.username}",
      conversation_id: conversation.id
    )
  end

  def send_email(conversation, recipient)
    return unless recipient && recipient.message_email_notification_allowed?

    ::ConversationMailer.message_notification(recipient).deliver_later
  end
end
