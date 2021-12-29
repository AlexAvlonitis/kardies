require 'rails_helper'

describe Conversations::GetUnreadConversationsService do
  let(:subject) { described_class.new(MailboxStub.new) }

  class MailboxStub
    def inbox(params)
      conversation = OpenStruct.new(id: '1', body: 'test conversation 1', is_read: false)
      conversation2 = OpenStruct.new(id: '2', body: 'test conversation 1', is_read: true)
      conversations = [conversation2, conversation]

      params[:unread] ? conversations.reject(&:is_read) : conversations
    end
  end

  describe '#call' do
    it 'returns only the unread conversation IDs of the user' do
      expect(subject.call).to eq [1]
    end
  end
end
