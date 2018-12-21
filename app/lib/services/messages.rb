module Services
  class Messages
    def initialize(current_user)
      @current_user = current_user
    end

    def find_existing_conversation(conversation_id, recipient)
      return Mailboxer::Conversation.find(conversation_id) if conversation_id

      conversation = Mailboxer::Conversation
                     .between(current_user, recipient)
                     .find { |c| c.participants.count == 2 }

      return unless conversation
      return if conversation_deleted?(conversation, recipient)
      conversation
    end

    def conversation_deleted?(conversation, recipient)
      return unless conversation

      conversation.is_deleted?(current_user) ||
        conversation.is_deleted?(recipient)
    end

    def add_notifications(recipient)
      add_conversation_notification(recipient)
      conversation_notification_email(recipient)
    end

    private

    attr_reader :current_user

    def add_conversation_notification(recipient)
      ConversationNotification.create(
        user_id: recipient.id,
        receiver_id: current_user.id,
        received: true
      )
    end

    def conversation_notification_email(recipient)
      Notifications::Conversations.new(recipient).execute
    end
  end
end
