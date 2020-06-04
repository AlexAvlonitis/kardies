# frozen_string_literal: true

module Services
  class Memberships
    CANCELED = 'canceled'
    PAYMENT_PLAN = {
      monthly: 'plan_HBdQUh05ZOv6op',
      six_months: 'plan_HBdYuxomnTN9l6',
      yearly: 'plan_HBdYVDluKzQMir'
    }.freeze

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def create
      raise Errors::Memberships::DenyError if subscription_active?

      subs = Stripe::Subscription.create(
        {
          customer: customer,
          items: [
            {
              plan: PAYMENT_PLAN[params[:payment_plan]&.to_sym]
            }
          ],
          expand: ['latest_invoice.payment_intent']
        },
        {
          idempotency_key: params[:idempotency_key]
        }
      )
      current_user.membership.update(subscription_id: subs.id)
      subs
    end

    def store_membership
      subs = retrieve_membership
      unless subs.customer == current_user.membership.customer_id
        raise Errors::Memberships::PermissionError
      end

      current_user.membership.update(
          expiry_date: Time.at(subs.current_period_end),
          active: true
        )
      subs
    end

    def retrieve_membership
      Stripe::Subscription.retrieve(subscription_id) if subscription_id
    end

    def cancel
      raise Errors::Memberships::InactiveError unless subscription_id

      subscription = Stripe::Subscription.delete(subscription_id)
      return cancel_subscription(subscription) if subscription.status == CANCELED

      raise Errors::Memberships::UndefinedError
    end

    private

    attr_reader :current_user, :params

    def cancel_subscription(subscription)
      current_user.membership.update(active: false)
      subscription
    end

    def subscription_active?
      current_user&.membership&.active
    end

    def subscription_id
      current_user&.membership&.subscription_id
    end

    def customer
      return create_customer.id unless customer_id

      unless params[:payment_method] == customer_payment_method&.data&.first&.id
        attach_payment_method
        update_customer_default_payment_method
      end
      customer_id
    end

    def customer_id
      current_user&.membership&.customer_id
    end

    def update_customer_default_payment_method
      Stripe::Customer.update(
        customer_id,
        {
          invoice_settings: {
            default_payment_method: params[:payment_method]
          }
        }
      )
    end

    def customer_payment_method
      Stripe::PaymentMethod.list({
          customer: customer_id,
          type: 'card',
        })
    end

    def attach_payment_method
      Stripe::PaymentMethod.attach(
          params[:payment_method],
          {customer: customer_id},
        )
    end

    def create_customer
      customer = Stripe::Customer.create(
          payment_method: params[:payment_method],
          email: current_user.email,
          invoice_settings: {
            default_payment_method: params[:payment_method]
          }
        )
      store_customer(customer)
      customer
    end

    def store_customer(customer)
      subs = Membership.create(customer_id: customer.id)
      current_user.membership = subs
    end
  end
end
