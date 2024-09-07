module Memberships
  module StripeHelpers
    def create_subscription(customer, payment_plan, idempotency_key)
      Stripe::Subscription.create(
        {
          customer: customer,
          items: [{ plan: payment_plan }],
          expand: ['latest_invoice.payment_intent']
        },
        {
          idempotency_key: idempotency_key
        }
      )
    end

    def fetch_customer_payment_method(customer_id)
      Stripe::PaymentMethod.list({ customer: customer_id, type: 'card' })
    end

    def fetch_subscription(subscription_id)
      Stripe::Subscription.retrieve(subscription_id)
    end

    def attach_payment_method(payment_method, customer_id)
      Stripe::PaymentMethod.attach(payment_method, { customer: customer_id })
    end

    def update_default_payment_method(payment_method, customer_id)
      Stripe::Customer.update(
        customer_id,
        {
          invoice_settings: {
            default_payment_method: payment_method
          }
        }
      )
    end

    def create_customer(payment_method, email)
      Stripe::Customer.create(
        payment_method: payment_method,
        email: email,
        invoice_settings: {
          default_payment_method: payment_method
        }
      )
    end

    def cancel_subscription(subscription_id)
      Stripe::Subscription.cancel(subscription_id)
    end
  end
end
