module Conversations
  class DeleteAllConversationsService < BaseService
    def initialize(current_user)
      @current_user = current_user
      @mailbox = current_user.mailbox
    end

    def call
      mailbox.conversations.each do |convo|
        convo.mark_as_deleted(current_user)
      end
    end

    private

    attr_reader :current_user, :mailbox
  end
end
