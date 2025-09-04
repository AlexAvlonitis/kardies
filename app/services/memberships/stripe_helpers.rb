module Memberships
  module StripeHelpers
    def create_checkout_session(customer, payment_plan, success_url, cancel_url, idempotency_key)
      Stripe::Checkout::Session.create(
        {
          customer: customer,
          payment_method_types: ['card'],
          line_items: [
            {
              price: payment_plan,
              quantity: 1,
            },
          ],
          mode: 'subscription',
          success_url: success_url,
          cancel_url: cancel_url,
        },
        {
          idempotency_key: idempotency_key
        }
      )
    end

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
      if payment_method.present?
        Stripe::Customer.create(
          payment_method: payment_method,
          email: email,
          invoice_settings: {
            default_payment_method: payment_method
          }
        )
      else
        # For checkout sessions, we don't have a payment method yet
        Stripe::Customer.create(
          email: email
        )
      end
    end

    def cancel_subscription(subscription_id)
      Stripe::Subscription.cancel(subscription_id)
    end

    def find_price_by_product_id(product_id)
      # Get all prices for the product
      prices = Stripe::Price.list(product: product_id, active: true, limit: 1)

      # Return the first active price (most recent one)
      if prices && prices.data.any?
        prices.data.first.id
      else
        raise "No active price found for product: #{product_id}"
      end
    end

    def fetch_customer(customer_id)
      Stripe::Customer.retrieve(customer_id)
    end

    def fetch_customer_recent_invoices(customer_id, limit = 1)
      Stripe::Invoice.list({
        customer: customer_id,
        limit: limit
      })
    end

    def fetch_customer_subscriptions(customer_id, status = 'active', limit = 1)
      Stripe::Subscription.list({
        customer: customer_id,
        status: status,
        limit: limit
      })
    end

    # Helper to determine the plan duration based on plan ID
    def determine_plan_duration(plan_id)
      if plan_id == ENV['MONTHLY_SUBSCRIPTION_PLAN']
        :monthly
      elsif plan_id == ENV['SIX_MONTHS_SUBSCRIPTION_PLAN']
        :six_months
      elsif plan_id == ENV['YEARLY_SUBSCRIPTION_PLAN']
        :yearly
      else
        # Default fallback
        :monthly
      end
    end
  end
end
