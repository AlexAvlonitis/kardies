module Memberships
  class ProcessPaymentSuccessService < BaseService
    include StripeHelpers

    def initialize(current_user)
      @current_user = current_user
    end

    def call
      # Make sure we have a membership object to work with
      ensure_local_membership_exists!

      # First try to find an existing subscription
      subscription = find_subscription_by_customer

      # If we have a subscription, update the local membership with it
      if subscription
        update_local_membership!(subscription)
        return { message: "Membership successfully updated", subscription: subscription }
      else
        # If there's no subscription yet (which shouldn't happen often with Checkout),
        # we'll still activate the membership locally
        activate_membership!
        return { message: "Membership activated without subscription details" }
      end
    end

    private

    attr_reader :current_user

    def ensure_local_membership_exists!
      # If the user doesn't have a membership record yet, create one
      if current_user.membership.blank?
        # First try to create a customer in Stripe
        stripe_customer = create_customer(nil, current_user.email)
        create_local_membership!(stripe_customer.id)
      elsif current_user.membership.active.blank? || current_user.membership.expiry_date.blank?
        # If membership exists but active status or expiry_date is not set, update it
        plan_duration = determine_plan_duration_from_stripe
        expiry_date = calculate_expiry_date(plan_duration)

        current_user.membership.update!(
          active: true,
          expiry_date: expiry_date
        )
      end
    end

    def create_local_membership!(customer_id)
      # Try to determine the plan duration (defaults to monthly if can't determine)
      plan_duration = determine_plan_duration_from_stripe
      expiry_date = calculate_expiry_date(plan_duration)

      membership = Membership.create!(
        customer_id: customer_id,
        active: true,
        expiry_date: expiry_date
      )
      current_user.update!(membership: membership)
    end

    def find_subscription_by_customer
      return nil unless current_user&.membership&.customer_id

      # Use stripe_helpers to fetch subscriptions
      subscriptions = fetch_customer_subscriptions(current_user.membership.customer_id)

      # Return the first active subscription if found
      subscriptions.data.first if subscriptions.data.any?
    end

    def update_local_membership!(subscription)
      # Extract Stripe subscription details
      price = subscription.items.data.first.price if subscription.items && subscription.items.data.any?
      amount = price.unit_amount if price && price.respond_to?(:unit_amount)
      interval = price.recurring.interval if price && price.recurring && price.recurring.respond_to?(:interval)
      interval_count = price.recurring.interval_count if price && price.recurring && price.recurring.respond_to?(:interval_count)

      # Calculate expiry date based on interval and interval_count
      expiry_date = if interval == 'month' && interval_count == 6
                      6.months.from_now
                    elsif interval == 'month' && interval_count == 1
                      1.month.from_now
                    elsif interval == 'year' && interval_count == 1
                      1.year.from_now
                    else
                      1.month.from_now
                    end

      current_user.membership.update!(
        subscription_id: subscription.id,
        expiry_date: expiry_date,
        active: true,
        amount: amount,
        interval: interval,
        interval_count: interval_count
      )
    end

    def activate_membership!
      # If we have no subscription data, try to determine the plan from Stripe products
      # and set expiry date accordingly
      plan_duration = determine_plan_duration_from_stripe
      expiry_date = calculate_expiry_date(plan_duration)

      current_user.membership.update(
        expiry_date: expiry_date,
        active: true
      )
    end

    # Try to determine the plan duration from Stripe products or customer metadata
    def determine_plan_duration_from_stripe
      # Default to monthly if we can't determine
      return :monthly unless current_user&.membership&.customer_id

      begin
        # Use stripe_helpers to fetch customer and invoices
        customer_id = current_user.membership.customer_id
        invoices = fetch_customer_recent_invoices(customer_id)

        if invoices.data.any?
          invoice = invoices.data.first

          # Try to determine plan from line items
          if invoice.lines.data.any?
            item = invoice.lines.data.first
            plan_id = item.plan&.id

            # Use stripe_helpers to determine the plan duration
            return determine_plan_duration(plan_id) if plan_id
          end
        end
      rescue => e
        # If there's an error, just default to monthly
        Rails.logger.error("Error determining plan from Stripe: #{e.message}")
      end

      # Default fallback
      :monthly
    end

    # Calculate expiry date based on the plan
    def calculate_expiry_date(plan_duration)
      case plan_duration
      when :monthly
        1.month.from_now
      when :six_months
        6.months.from_now
      when :yearly
        1.year.from_now
      else
        # Default fallback
        1.month.from_now
      end
    end
  end
end
