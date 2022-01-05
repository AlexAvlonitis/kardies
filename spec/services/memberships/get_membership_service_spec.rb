require 'rails_helper'

describe Memberships::GetMembershipService do
  let(:subject) { described_class.new(current_user) }

  let(:current_user) { double('current_user', email: 'test@test.com') }
  let(:membership) { double('membership', customer_id: 1) }
  let(:subscription) { double('subscription', id: 1) }

  before do
    allow(current_user).to receive(:membership).and_return(membership)
    allow(membership).to receive(:subscription_id) { subscription.id }
  end

  describe '#call' do
    context 'when a subscription_id exists in the db' do
      it 'fetches the subscription from stripe' do
        expect(Stripe::Subscription).to receive(:retrieve).with(subscription.id)

        subject.call
      end
    end

    context 'when a subscription_id does not exist in the db' do
      before do
        allow(membership).to receive(:subscription_id) { nil }
      end

      it 'does not fetch anything from stripe' do
        expect(Stripe::Subscription).not_to receive(:retrieve).with(subscription.id)
        subject.call
      end

      it 'returns nil' do
        expect(subject.call).to be_nil
      end
    end
  end
end
