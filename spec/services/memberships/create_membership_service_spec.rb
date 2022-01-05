require 'rails_helper'

describe Memberships::CreateMembershipService do
  let(:subject) { described_class.new(current_user, params) }

  let(:current_user) { double('current_user', email: 'test@test.com') }
  let(:membership) { double('membership', customer_id: 1) }
  let(:customer) { double('customer', id: 1) }
  let(:stripe_customer) { double('stripe_customer', id: 2) }
  let(:subscription) { double('subscription', id: 1) }
  let(:customer_payment_method) do
    double('payment_method',
      data: double('data',
        first: double('first',
          id: 'card'
        )
      )
    )
  end
  let(:params) do
    {
      payment_method: "card",
      payment_plan: "monthly",
      idempotency_key: 'random_key'
    }
  end

  before do
    allow(current_user).to receive(:membership).and_return(membership)

    allow(membership).to receive(:active).and_return(false)
    allow(membership).to receive(:update) { true }
  end

  describe '#call' do
    before do
      allow(ENV).to receive(:[]).with('MONTHLY_SUBSCRIPTION_PLAN').and_return('plan_123')
      allow(ENV).to receive(:[]).with('SIX_MONTHS_SUBSCRIPTION_PLAN').and_return('plan_six_123')
      allow(ENV).to receive(:[]).with('YEARLY_SUBSCRIPTION_PLAN').and_return('plan_year_123')

      allow(Stripe::PaymentMethod).to receive(:attach) { true }
      allow(Stripe::PaymentMethod).to receive(:list) { customer_payment_method }
      allow(Stripe::Customer).to receive(:update) { true }
    end

    context 'When a user\'s membership is already active' do
      it 'raises membership deny error' do
        allow(membership).to receive(:active) { true }

        expect { subject.call }.to raise_error(Errors::Memberships::DenyError)
      end
    end

    context 'When a the user\'s details are correct' do
      before do
        allow(Stripe::Subscription).to receive(:create).and_return(subscription)
      end

      context 'When the customer exists' do
        before do
          allow(membership).to receive(:customer_id) { 1 }
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

          subject.call
        end

        it 'receives the payment method from stripe' do
          expect(Stripe::PaymentMethod)
            .to receive(:list)
            .with(customer: customer.id, type: 'card')

          subject.call
        end

        context 'when payment method from stripe differs the one from params' do
          let(:params) { { payment_method: "cash" } }

          it 'attaches a new payment method to stripe' do
            expect(Stripe::PaymentMethod)
              .to receive(:attach)
              .with(params[:payment_method], { customer: customer.id })

            subject.call
          end

          it 'updates the default payment methods on stripe' do
            expect(Stripe::Customer)
              .to receive(:update)
              .with(
                customer.id,
                {
                  invoice_settings: {
                    default_payment_method: params[:payment_method]
                  }
                }
              )

            subject.call
          end
        end

        it 'records the subscription_id in the db' do
          expect(membership)
            .to receive(:update)
            .with(subscription_id: subscription.id)

          subject.call
        end
      end

      context 'When the customer does not exist' do
        before do
          allow(membership)
            .to receive(:customer_id)
            .and_return(nil)

          allow(Stripe::Customer)
            .to receive(:create)
            .and_return(stripe_customer)

          allow(Membership)
            .to receive(:create)
            .and_return(subscription)

          allow(current_user)
            .to receive(:membership=)
            .and_return(true)
        end

        it 'creates a new customer on stripe' do
          expect(Stripe::Customer)
            .to receive(:create)
            .with({
              payment_method: 'card',
              email: 'test@test.com',
              invoice_settings: {
                default_payment_method: 'card'
              }
            })
            .and_return(stripe_customer)

          subject.call
        end

        it 'records the stripe_customer_id in db' do
          expect(Membership)
            .to receive(:create)
            .with(customer_id: stripe_customer.id)
            .and_return(subscription)

          expect(current_user)
            .to receive(:membership=)
            .with(subscription)
            .and_return(true)

          subject.call
        end
      end
    end
  end
end
