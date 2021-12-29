require 'rails_helper'

describe Conversations::DeleteAllMessagesService do
  let(:subject) { described_class.new(current_user) }

  let(:current_user) { double(:user, mailbox: mailbox) }
  let(:mailbox) { double(:mailbox, conversations: [conversation, conversation2]) }
  let(:conversation) { double(:conversation, id: 1, body: 'test conversation 1') }
  let(:conversation2) { double(:conversation, id: 2, body: 'test conversation 1') }

  describe '#call' do
    it 'marks all conversations as deleted' do
      expect(conversation).to receive(:mark_as_deleted).with(current_user)
      expect(conversation2).to receive(:mark_as_deleted).with(current_user)

      subject.call
    end
  end
end
