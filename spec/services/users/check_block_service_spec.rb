require 'rails_helper'

describe Users::CheckBlockService do
  subject { described_class.new(current_user, user) }

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:user) { FactoryBot.build_stubbed(:user) }

  before do
    allow(current_user).to receive_message_chain(:blocked_users, :exists?) { false }
    allow(user).to receive_message_chain(:blocked_users, :exists?) { false }
  end

  describe '#call' do
    context 'when there are no blocks' do
      it 'returns false' do
        expect(subject.call).to eq false
      end
    end

    context 'when current user is blocked by user' do
      it 'returns true' do
        allow(current_user).to receive_message_chain(:blocked_users, :exists?) { true }
        expect(subject.call).to eq true
      end
    end

    context 'when user is blocked by current_user' do
      it 'returns true' do
        allow(user).to receive_message_chain(:blocked_users, :exists?) { true }
        expect(subject.call).to eq true
      end
    end
  end
end
