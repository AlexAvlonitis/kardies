module Api
  module V1
    class BlockedUsersController < ApiController
      def create
        @blocked_user = current_user.blocked_users.build(blocked_user_params)

        if @blocked_user.save
          render json: @blocked_user, status: :ok
        else
          render json: { errors: @blocked_user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        user = current_user.blocked_users.find_by(blocked_user_id: params[:id])&.destroy
        if user
          render json: user, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { errors: e }, status: :internal_server_error
      end

      private

      def blocked_user_params
        params.permit(:blocked_user_id)
      end
    end
  end
end
