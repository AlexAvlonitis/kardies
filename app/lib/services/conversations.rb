module Services
  class Conversations
    def initialize(current_user)
      @current_user = current_user
    end

    def all
      messages = mailbox.inbox + mailbox.sentbox
      messages.flatten.uniq(&:id)
    end

    def show(id)
      mailbox.conversations.find(id)
    end

    def unread
      mailbox.inbox(unread: true).map { |m| m.id.to_i }
    end

    def delete_all
      mailbox.conversations.each do |convo|
        convo.mark_as_deleted(current_user)
      end
    end

    private

    attr_reader :current_user

    def mailbox
      @mailbox ||= current_user.mailbox
    end
  end
end
