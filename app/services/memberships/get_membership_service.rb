module Memberships
  class GetMembershipService < BaseService
    include StripeHelpers

    def initialize(current_user)
      @current_user = current_user
    end

    def call
      fetch_subscription(subscription_id) if subscription_id
    end

    private

    attr_reader :current_user

    def subscription_id
      current_user&.membership&.subscription_id
    end
  end
end
