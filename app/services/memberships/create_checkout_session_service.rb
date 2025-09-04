module Memberships
  class CreateCheckoutSessionService < BaseService
    include StripeHelpers

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      raise Errors::Memberships::DenyError if subscription_active?

      checkout_session = create_checkout_session(
        customer,
        payment_plan(params[:payment_plan]),
        params[:success_url],
        params[:cancel_url],
        params[:idempotency_key]
      )

      # Return session ID for the frontend to redirect to checkout
      { sessionId: checkout_session.id }
    end

    private

    attr_reader :params, :current_user

    def subscription_active?
      current_user&.membership&.active
    end

    def customer
      if customer_id.blank?
        stripe_customer = create_customer(nil, current_user.email)
        create_local_membership!(stripe_customer.id)
        return stripe_customer.id
      end

      customer_id
    end

    def customer_id
      current_user&.membership&.customer_id
    end

    def create_local_membership!(customer_id)
      membership = Membership.create!(customer_id: customer_id)
      current_user.update!(membership: membership)
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
  end
end
