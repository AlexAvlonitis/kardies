class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation, current_user)
    recipient = find_recipient(conversation, current_user)
    add_conversation_notification(recipient.first, current_user)
  end

  def find_recipient(conversation, current_user)
    conversation.participants.select { |user| user != current_user }
  end

  def add_conversation_notification(recipient, current_user)
    ConversationNotification.create(user_id: recipient.id,
                                    receiver_id: current_user.id,
                                    received: true )
  end

end
