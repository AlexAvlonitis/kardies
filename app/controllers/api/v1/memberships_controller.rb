module Api
  module V1
    class MembershipsController < ApiController
      def checkout_session
        render_json(Memberships::CreateCheckoutSessionService.call(current_user, checkout_session_params))
      rescue StandardError => e
        render_json({ errors: e.message }, :unprocessable_entity)
      end

      def payment_success
        render_json(Memberships::ProcessPaymentSuccessService.call(current_user))
      rescue StandardError => e
        render_json({ errors: e.message }, :unprocessable_entity)
      end

      def retrieve_membership
        render_json(Memberships::GetMembershipService.call(current_user))
      rescue StandardError => e
        render_json({ errors: e.message }, :unprocessable_entity)
      end

      def destroy
        render_json(Memberships::CancelMembershipService.call(current_user))
      rescue StandardError => e
        render_json({ errors: e.message }, :unprocessable_entity)
      end

      private

      def render_json(payload, status = :ok)
        render json: payload.to_json, status: status
      end

      def membership_params
        params.permit(allowed_params)
      end

      def allowed_params
        %i[payment_plan payment_method idempotency_key]
      end

      def checkout_session_params
        params.permit(%i[payment_plan idempotency_key success_url cancel_url])
      end
    end
  end
end
