require 'rails_helper'

describe Conversations::GetAllConversationsService do
  let(:subject) { described_class.new(mailbox) }

  let(:mailbox) { double(:mailbox, inbox: [conversation], sentbox: [conversation2]) }
  let(:conversation) { double(:conversation, id: 1, body: 'test conversation 1') }
  let(:conversation2) { double(:conversation, id: 2, body: 'test conversation 1') }

  describe '#call' do
    it 'returns all the conversations of the user' do
      expect(subject.call).to eq [conversation, conversation2]
    end

    context 'where there are duplicate conversations' do
      let(:mailbox) do
        double(:mailbox, inbox: [conversation, conversation], sentbox: [conversation2])
      end

      it 'returns only the unique conversations' do
        expect(subject.call).to eq [conversation, conversation2]
      end
    end
  end
end
