require 'rails_helper'

describe Memberships::StripeHelpers do
  let(:subject) do
    class Test
      include Memberships::StripeHelpers
    end.new
  end

  let(:customer) { double('customer', id: 1, email: 'test@test.com') }
  let(:subscription) { double('subcription', id: 1) }
  let(:payment_plan) { 'payment_plan_id' }
  let(:idempotency_key) { 'random_key' }
  let(:payment_method) { 'card' }

  before do
    allow(Stripe::Subscription).to receive(:create)
    allow(Stripe::Subscription).to receive(:retrieve)
    allow(Stripe::Subscription).to receive(:cancel)
    allow(Stripe::PaymentMethod).to receive(:list)
    allow(Stripe::PaymentMethod).to receive(:attach)
    allow(Stripe::Customer).to receive(:update)
  end

  describe '#create_subscription' do
    specify do
      expect(Stripe::Subscription)
        .to receive(:create)
        .with(
          {
            customer: customer,
            items: [{ plan: payment_plan }],
            expand: ['latest_invoice.payment_intent']
          },
          {
            idempotency_key: idempotency_key
          }
        )

      subject.create_subscription(customer, payment_plan, idempotency_key)
    end
  end

  describe '#fetch_customer_payment_method' do
    specify do
      expect(Stripe::PaymentMethod)
        .to receive(:list)
        .with({ customer: customer.id, type: 'card' })

      subject.fetch_customer_payment_method(customer.id)
    end
  end

  describe '#fetch_subscription' do
    specify do
      expect(Stripe::Subscription).to receive(:retrieve).with(subscription.id)

      subject.fetch_subscription(subscription.id)
    end
  end

  describe '#attach_payment_method' do
    specify do
      expect(Stripe::PaymentMethod)
        .to receive(:attach)
        .with(payment_method, { customer: customer.id })

      subject.attach_payment_method(payment_method, customer.id)
    end
  end

  describe '#update_default_payment_method' do
    specify do
      expect(Stripe::Customer)
        .to receive(:update)
        .with(
          customer.id,
          {
            invoice_settings: {
              default_payment_method: payment_method
            }
          }
        )

      subject.update_default_payment_method(payment_method, customer.id)
    end
  end

  describe '#create_customer' do
    specify do
      expect(Stripe::Customer)
        .to receive(:create)
        .with(
          payment_method: payment_method,
          email: customer.email,
          invoice_settings: {
            default_payment_method: payment_method
          }
        )

      subject.create_customer(payment_method, customer.email)
    end
  end

  describe '#cancel_subscription' do
    specify do
      expect(Stripe::Subscription).to receive(:cancel).with(subscription.id)

      subject.cancel_subscription(subscription.id)
    end
  end
end
