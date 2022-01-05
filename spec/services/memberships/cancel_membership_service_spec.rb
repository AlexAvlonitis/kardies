require 'rails_helper'

describe Memberships::CancelMembershipService do
  let(:subject) { described_class.new(current_user) }

  let(:current_user) { double('current_user', email: 'test@test.com') }
  let(:membership) { double('membership', customer_id: 1) }
  let(:subscription) { double('subscription', id: 1) }

  before do
    allow(current_user).to receive(:membership).and_return(membership)
    allow(membership).to receive(:subscription_id) { subscription.id }
    allow(membership).to receive(:update) { true }
    allow(subscription).to receive(:status) { 'canceled' }

    allow(Stripe::Subscription).to receive(:delete) { subscription }
  end

  describe '#call' do
    context 'when a subscription_id exists in the db' do
      it 'deletes it from Stripe' do
        expect(Stripe::Subscription).to receive(:delete).with(subscription.id)

        subject.call
      end

      it 'updates the active flag in the db' do
        expect(membership).to receive(:update).with(active: false)

        subject.call
      end
    end

    context 'when a subscription_id does not exist in the db' do
      it 'raises inactive error' do
        allow(membership).to receive(:subscription_id) { nil }

        expect { subject.call }.to raise_error(Errors::Memberships::InactiveError)
      end
    end

    context 'when a subscription from stripe has failed to cancel' do
      it 'raises an undefined error' do
        allow(subscription).to receive(:status) { 'active' }

        expect { subject.call }.to raise_error(Errors::Memberships::UndefinedError)
      end
    end
  end
end
