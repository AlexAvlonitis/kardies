module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: :show

      def index
        render json: users.all, status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      private

      def set_user
        @user = User.find_by!(username: params[:username])
        authorize @user
      end

      def users
        @users ||= Services::Users.new(current_user, params[:page])
      end
    end
  end
end
