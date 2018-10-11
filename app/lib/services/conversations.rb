module Services
  class Conversations
    def initialize(current_user)
      @current_user = current_user
      mailbox
    end

    def all
      get_messages
    end

    def show(id)
      @mailbox.conversations.find(id)
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

    def get_messages
      messages = @mailbox.inbox + @mailbox.sentbox
      messages.flatten.uniq(&:id)
    end
  end
end
