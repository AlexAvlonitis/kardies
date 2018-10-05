require 'rails_helper'

describe Services::Messages do
  subject { described_class }

  let(:conversation_klass) { Mailboxer::Conversation }
  let(:conversation) { double('conversation') }
  let(:current_user) { double('current_user') }
  let(:recipient) { double('recipient') }

  before do
    allow(conversation_klass).to receive(:find).with(1) { conversation }
    allow(conversation_klass).to receive_message_chain(:between, :find)
  end

  describe '#find_existing_conversation' do
    context 'when we add a conversation_id as a param' do
      it 'tries to find an existing conversation by id' do
        expect(conversation_klass).to receive(:find).with(1)
        subject.find_existing_conversation(1, current_user, recipient)
      end
    end

    context 'when the conversation_id param is nil' do
      it 'tries to find an existing conversation by participants' do
        expect(conversation_klass).to receive_message_chain(:between, :find)
        subject.find_existing_conversation(nil, current_user, recipient)
      end
    end
  end

  describe '#conversation_deleted?' do
    context 'when a conversation does not exist' do
      it 'returns nil' do
        expect(subject.conversation_deleted?(nil, current_user, recipient)).to eq nil
      end
    end

    context 'when a conversation is deleted by one participant' do
      it 'returns deleted? true' do
        allow(conversation).to receive(:is_deleted?).with(current_user) { true }
        allow(conversation).to receive(:is_deleted?).with(recipient) { false }

        expect(subject.conversation_deleted?(conversation, current_user, recipient)).to eq true
      end

      it 'returns deleted? true' do
        allow(conversation).to receive(:is_deleted?).with(current_user) { false }
        allow(conversation).to receive(:is_deleted?).with(recipient) { true }

        expect(subject.conversation_deleted?(conversation, current_user, recipient)).to eq true
      end
    end

    context 'when a conversation is not deleted by any participant' do
      it 'returns deleted? false' do
        allow(conversation).to receive(:is_deleted?).with(current_user) { false }
        allow(conversation).to receive(:is_deleted?).with(recipient) { false }

        expect(subject.conversation_deleted?(conversation, current_user, recipient)).to eq false
      end
    end
  end
end
