require 'rails_helper'

describe MembershipsService do
  let(:subject) { described_class.new(current_user, params) }

  let(:current_user) { double('current_user', email: 'test@test.com') }
  let(:membership) { double('membership', customer_id: 1) }
  let(:customer) { double('customer', id: 1) }
  let(:stripe_customer) { double('stripe_customer', id: 2) }
  let(:subscription) { double('subscription', id: 1) }
  let(:customer_payment_method) do
    double('payment_method',
      data: double('data',
        first: double('first', id: 'card')))
  end
  let(:params) do
    {
      payment_method: "card",
      payment_plan: "monthly"
    }
  end

  before do
    allow(current_user).to receive(:membership).and_return(membership)

    allow(membership).to receive(:active).and_return(false)
    allow(membership).to receive(:update) { true }
  end

  describe '#create' do
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

        expect { subject.create }.to raise_error(Errors::Memberships::DenyError)
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

          subject.create
        end

        it 'records the subscription_id in the db' do
          expect(membership)
            .to receive(:update)
            .with(subscription_id: subscription.id)

          subject.create
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

          subject.create
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

          subject.create
        end
      end
    end
  end

  describe '#store_membership' do
    before do
      allow(membership).to receive(:subscription_id) { '123' }

      allow(Stripe::Subscription)
        .to receive(:retrieve)
        .and_return(subscription)

      allow(subscription).to receive(:customer) { 1 }
      allow(subscription).to receive(:current_period_end) { 7428313 }
    end

    context 'When a subscription_id already exists in the db' do
      it 'retrieves the subscription from stripe' do
        expect(Stripe::Subscription)
          .to receive(:retrieve)
          .with('123')
          .and_return(subscription)

        subject.store_membership
      end

      it 'stores the expiry date and active flag in the db' do
        expect(membership)
          .to receive(:update)
          .with({
            expiry_date: Time.at(7428313),
            active: true
          })
          .and_return(true)

        subject.store_membership
      end
    end

    context 'When a subscription_id does not exist in the db' do
      it 'raises a permission error' do
        allow(membership).to receive(:subscription_id) { nil }

        expect { subject.store_membership }
          .to raise_error(Errors::Memberships::PermissionError)
      end
    end

    context 'When the fetched subscription from stripe belongs to a different customer' do
      it 'raises a permission error' do
        allow(subscription).to receive(:customer) { 3290234 }

        expect { subject.store_membership }
          .to raise_error(Errors::Memberships::PermissionError)
      end
    end
  end

  describe '#cancel' do
    before do
      allow(membership).to receive(:subscription_id) { '123' }
      allow(subscription).to receive(:status) { 'canceled' }

      allow(Stripe::Subscription).to receive(:cancel) { subscription }
    end

    context 'when a subscription_id exists in the db' do
      it 'cancels it on Stripe' do
        expect(Stripe::Subscription)
          .to receive(:cancel)
          .with('123')
          .and_return(subscription)

        subject.cancel
      end

      it 'updates the active flag in the db' do
        expect(membership)
          .to receive(:update)
          .with(active: false)
          .and_return(true)

        subject.cancel
      end
    end

    context 'when a subscription_id does not exist in the db' do
      it 'raises inactive error' do
        allow(membership).to receive(:subscription_id) { nil }

        expect { subject.cancel }
          .to raise_error(Errors::Memberships::InactiveError)
      end
    end

    context 'when a subscription from stripe has failed to cancel' do
      it 'raises an undefined error' do
        allow(subscription).to receive(:status) { 'active' }

        expect { subject.cancel }
          .to raise_error(Errors::Memberships::UndefinedError)
      end
    end
  end
end
