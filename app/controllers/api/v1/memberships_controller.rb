module Api
  module V1
    class MembershipsController < ApiController
      def create
        render_json(Memberships::CreateMembershipService.call(current_user, membership_params))
      rescue StandardError => e
        render_json({ errors: e.message }, :unprocessable_entity)
      end

      def store_membership
        render_json(Memberships::UpdateMembershipService.call(current_user))
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
    end
  end
end
