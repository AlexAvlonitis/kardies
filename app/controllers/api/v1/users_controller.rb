module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: :show

      def index
        users = Users::GetAllUsersService.call(current_user, params[:page])
        render json: users, status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      def destroy
        UserDecorator.new(current_user).destroy
        render json: { message: 'Ο λογαριασμός διαγράφηκε' }, status: :ok
      rescue StandardError => e
        Rails::Logger.error e
        render json: { message: 'Κάτι πήγε στραβά' }, status: :unprocessable_entity
      end

      private

      def set_user
        @user = User.find_by!(username: params[:username])
        authorize @user
      end
    end
  end
end
