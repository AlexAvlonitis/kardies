module Conversations
  class GetUnreadConversationsService < BaseService
    def initialize(mailbox)
      @mailbox = mailbox
    end

    def call
      mailbox.inbox(unread: true).map { |m| m.id.to_i }
    end

    private

    attr_reader :mailbox
  end
end
