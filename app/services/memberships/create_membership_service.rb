module Memberships
  class CreateMembershipService < BaseService
    include StripeHelpers

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      raise Errors::Memberships::DenyError if subscription_active?

      subscription = create_subscription(
          customer,
          payment_plan(params[:payment_plan]),
          params[:idempotency_key]
        )
      update_local_membership!(subscription.id)
      subscription
    end

    private

    attr_reader :params, :current_user

    def subscription_active?
      current_user&.membership&.active
    end

    def customer
      if customer_id.blank?
        stripe_customer = create_customer(params[:payment_method], current_user.email)
        create_local_membership!(stripe_customer.id)
        return stripe_customer.id
      end

      if payment_method_changed?
        attach_payment_method(params[:payment_method], customer_id)
        update_default_payment_method(params[:payment_method], customer_id)
      end
      customer_id
    end

    def payment_method_changed?
      payment_method = fetch_customer_payment_method(customer_id)
      params[:payment_method] != payment_method&.data&.first&.id
    end

    def customer_id
      current_user&.membership&.customer_id
    end

    def create_local_membership!(customer_id)
      membership = Membership.create(customer_id: customer_id)
      current_user.membership = membership
    end

    def payment_plan(plan)
      return unless plan

      plans = {
        monthly: ENV['MONTHLY_SUBSCRIPTION_PLAN'],
        six_months: ENV['SIX_MONTHS_SUBSCRIPTION_PLAN'],
        yearly: ENV['YEARLY_SUBSCRIPTION_PLAN']
      }
      plans[plan.to_sym]
    end

    def update_local_membership!(subscription_id)
      current_user.membership.update(subscription_id: subscription_id)
    end
  end
end
