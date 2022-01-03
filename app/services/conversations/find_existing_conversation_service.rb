module Conversations
  class FindExistingConversationService < BaseService
    def initialize(current_user, conversation_id, recipient)
      @current_user = current_user
      @conversation_id = conversation_id
      @recipient = recipient
    end

    def call
      return Mailboxer::Conversation.find(conversation_id) if conversation_id
      return unless existing_conversation
      return if conversation_deleted?

      existing_conversation
    end

    private

    attr_reader :current_user, :conversation_id, :recipient

    def conversation_deleted?
      existing_conversation.is_deleted?(current_user) ||
        existing_conversation.is_deleted?(recipient)
    end

    def existing_conversation
      @existing_conversation ||=
        Mailboxer::Conversation
          .between(current_user, recipient)
          .find { |c| c.participants.count == 2 }
    end
  end
end
