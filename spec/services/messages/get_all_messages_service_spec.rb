require 'rails_helper'

describe Messages::GetAllMessagesService do
  let(:subject) { described_class.new(current_user, conversation) }

  let(:current_user) { double(:user) }
  let(:conversation) do
    double(:conversation,
      id: 1,
      is_read?: is_read,
      mark_as_read: nil,
      receipts_for: nil
    )
  end
  let(:is_read) { false }

  before do
    allow(conversation).to receive(:receipts_for) { [] }
  end

  describe '#call' do
    context 'when conversation is unread' do
      it 'marks the conversation as read' do
        expect(conversation).to receive(:mark_as_read).with(current_user)

        subject.call
      end
    end

    context 'when conversation is read' do
      let(:is_read) { true }

      it 'does not mark the conversations as read' do
        expect(conversation).not_to receive(:mark_as_read).with(current_user)

        subject.call
      end
    end

    it 'gets the user\'s messages' do
      expect(conversation).to receive(:receipts_for).with(current_user)

      subject.call
    end
  end
end
