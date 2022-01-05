module Memberships
  class UpdateMembershipService < BaseService
    include StripeHelpers

    def initialize(current_user)
      @current_user = current_user
    end

    def call
      subscription = fetch_subscription(subscription_id)
      unless subscription_matches_customers?(subscription)
        raise Errors::Memberships::PermissionError
      end

      update_local_membership!(subscription)
      subscription
    end

    private

    attr_reader :current_user

    def subscription_id
      current_user&.membership&.subscription_id
    end

    def subscription_matches_customers?(subscription)
      subscription&.customer == current_user.membership.customer_id
    end

    def update_local_membership!(subscription)
      current_user.membership.update(
          expiry_date: Time.at(subscription.current_period_end),
          active: true
        )
    end
  end
end
