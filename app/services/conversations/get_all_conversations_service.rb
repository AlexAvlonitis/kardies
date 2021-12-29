module Conversations
  class GetAllConversationsService < BaseService
    def initialize(mailbox)
      @mailbox = mailbox
    end

    def call
      messages = mailbox.inbox + mailbox.sentbox
      messages.flatten.uniq(&:id)
    end

    private

    attr_reader :mailbox
  end
end
