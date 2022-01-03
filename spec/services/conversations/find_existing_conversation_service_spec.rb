require 'rails_helper'

describe Conversations::FindExistingConversationService do
  subject { described_class.new(current_user, conversation_id, recipient) }

  let(:conversation_klass) { Mailboxer::Conversation }
  let(:conversation) { double('conversation', id: conversation_id) }
  let(:conversation_id) { 1 }
  let(:current_user) { double('current_user') }
  let(:recipient) { double('recipient') }

  before do
    allow(conversation_klass).to receive(:find) { conversation }
    allow(conversation_klass)
      .to receive_message_chain(:between, :find)
      .and_return(conversation)
    allow(conversation).to receive(:is_deleted?).with(current_user) { false }
    allow(conversation).to receive(:is_deleted?).with(recipient) { false }
  end

  describe '#call' do
    context 'when we add a conversation_id as a param' do
      it 'tries to find an existing conversation by id' do
        expect(conversation_klass).to receive(:find).with(1) { conversation }
        subject.call
      end

      context 'and it cannot find a conversation' do
        it 'returns nil' do
          allow(conversation_klass).to receive(:find) { nil }
          expect(subject.call).to be_nil
        end
      end
    end

    context 'when the conversation_id param is nil' do
      let(:conversation_id) { nil }

      it 'tries to find an existing conversation by participants' do
        expect(conversation_klass).not_to receive(:find).with(1)
        expect(conversation_klass).to receive_message_chain(:between, :find)
        subject.call
      end
    end

    context 'when the conversation exists and is not deleted' do
      it 'returns the conversation' do
        expect(subject.call).to eq conversation
      end
    end

    context 'when a conversation is deleted' do
      before do
        allow(conversation_klass).to receive(:find) { nil }
      end

      context 'by current user'
        it 'returns nil' do
          allow(conversation).to receive(:is_deleted?).with(current_user) { true }
          allow(conversation).to receive(:is_deleted?).with(recipient) { false }

          expect(subject.call).to be_nil
        end

      context 'by the other user' do
        it 'returns nil' do
          allow(conversation).to receive(:is_deleted?).with(current_user) { false }
          allow(conversation).to receive(:is_deleted?).with(recipient) { true }

          expect(subject.call).to be_nil
        end
      end
    end
  end
end
