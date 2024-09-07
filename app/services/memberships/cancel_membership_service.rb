module Memberships
  class CancelMembershipService < BaseService
    include StripeHelpers

    CANCELED = 'canceled'

    def initialize(current_user)
      @current_user = current_user
    end

    def call
      raise Errors::Memberships::InactiveError unless subscription_id

      subscription = cancel_subscription(subscription_id)
      if subscription.status == CANCELED
        cancel_local_subscription!
        return subscription
      end

      raise Errors::Memberships::UndefinedError
    end

    private

    attr_reader :current_user

    def subscription_id
      current_user&.membership&.subscription_id
    end

    def cancel_local_subscription!
      current_user.membership.update(active: false)
    end
  end
end
