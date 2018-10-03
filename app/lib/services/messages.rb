module Services
  class Messages
    class << self
      def find_existing_conversation(conversation_id, current_user, recipient)
        return Mailboxer::Conversation.find(conversation_id) if conversation_id

        Mailboxer::Conversation
          .between(current_user, recipient)
          .find { |c| c.participants.count == 2 }
      end

      def conversation_deleted?(conversation, current_user, recipient)
        return unless conversation

        conversation.is_deleted?(current_user) ||
          conversation.is_deleted?(@recipient)
      end
    end
  end
end
