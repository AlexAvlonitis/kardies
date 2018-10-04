module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: :show

      def index
        render json: all_users, status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      private

      def set_user
        @user = User.find_by!(username: params[:username])
        authorize @user
      end

      def all_users
        @all_users ||= Services::Users.new(current_user, params[:page]).all
      end
    end
  end
end
