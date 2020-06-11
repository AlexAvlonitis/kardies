require 'rails_helper'

RSpec.describe Services::Memberships do
  let(:subject) { described_class.new(current_user, params) }

  let(:current_user) { double('current_user', email: 'test@test.com') }
  let(:membership) { double('membership') }
  let(:customer) { double('customer', id: 1) }
  let(:subscription) { double('subscription', id: 1) }
  let(:customer_payment_method) do
    double('payment_method',
      data: double('data',
        first: double('first', id: 'card')))
  end
  let(:params) do
    {
      payment_methods: "card",
      payment_plan: "monthly"
    }
  end

  describe '#create' do
    before do
      allow(ENV).to receive(:[]).with('MONTHLY_SUBSCRIPTION_PLAN').and_return('plan_123')
      allow(ENV).to receive(:[]).with('SIX_MONTHS_SUBSCRIPTION_PLAN').and_return('plan_six_123')
      allow(ENV).to receive(:[]).with('YEARLY_SUBSCRIPTION_PLAN').and_return('plan_year_123')

      allow(current_user)
        .to receive(:membership)
        .and_return(membership)

      allow(membership)
        .to receive(:active)
        .and_return(false)

      allow(Stripe::PaymentMethod).to receive(:attach) { true }
      allow(Stripe::PaymentMethod).to receive(:list) { customer_payment_method }
      allow(Stripe::Customer).to receive(:update) { true }
    end

    context 'When a user\'s membership is already active' do
      before do
        allow(membership)
          .to receive(:active)
          .and_return(true)
      end

      it 'raises membership deny error' do
        expect { subject.create }.to raise_error(Errors::Memberships::DenyError)
      end
    end

    context 'When a the user\'s details are correct' do
      context 'When the customer exists' do
        before do
          allow(Stripe::Subscription)
            .to receive(:create)
            .and_return(subscription)

          allow(membership)
            .to receive(:update)
            .and_return(true)

          allow(membership)
            .to receive(:customer_id)
            .and_return(1)
        end

        it 'create a subscription on stripe' do
          expect(Stripe::Subscription)
            .to receive(:create)
            .with(
              {
                customer: customer.id,
                items: [{ plan: 'plan_123' }],
                expand: ['latest_invoice.payment_intent']
              },
              { idempotency_key: params[:idempotency_key] }
            )
            .and_return(subscription)

          subject.create
        end
      end
    end
  end
end
