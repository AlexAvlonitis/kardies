module Messages
  class GetAllMessagesService < BaseService
    LIMIT_MESSAGES = 50

    def initialize(current_user, conversation)
      @current_user = current_user
      @conversation = conversation
    end

    def call
      mark_as_read
      messages
    end

    private

    attr_reader :current_user, :conversation

    def mark_as_read
      return if conversation.is_read?(current_user)

      conversation.mark_as_read(current_user)
    end

    def messages
      conversation
        .receipts_for(current_user)
        .last(LIMIT_MESSAGES)
        .map(&:message)
    end
  end
end
