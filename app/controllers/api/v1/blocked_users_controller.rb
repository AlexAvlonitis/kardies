module Api
  module V1
    class BlockedUsersController < ApiController
      before_action :set_user, only: [:create, :destroy]

      def index
        blocked_users = current_user.blocked_users.all

        render json: blocked_users, status: :ok
      end

      def create
        blocked_user = current_user.blocked_users.build(blocked_user_id: @user.id)

        if blocked_user.save
          render json: blocked_user, status: :ok
        else
          render json: { errors: blocked_user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        blocked_user =
          current_user.blocked_users.find_by!(blocked_user_id: @user.id)

        blocked_user.destroy
        render json: blocked_user, status: :ok
      end

      private

      def blocked_user_params
        params.permit(:username)
      end

      def set_user
        @user = User.find_by!(username: params[:username])
      end
    end
  end
end
