module Api
  module V1
    class MembershipsController < ApiController
      def create
        render_json(membership_service.create)

        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
      end

      def store_membership
        render_json(membership_service.store_membership)

        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
      end

      def retrieve_membership
        render_json(membership_service.retrieve_membership)
      end

      def destroy
        render_json(membership_service.cancel)

        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
      end

      private

      def render_json(payload)
        render json: payload.to_json, status: :ok
      end

      def membership_service
        @membership_service ||=
          MembershipsService.new(current_user, membership_params)
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
