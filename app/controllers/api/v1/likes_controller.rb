module Api
  module V1
    class LikesController < ApiController
      before_action :set_user, only: :create

      def index
        likes.delete_all_notifications
        render json: likes.sorted, status: :ok
      end

      def create
        if current_user.voted_for? @user
          render json: { errors: 'Έχετε ήδη στείλει καρδιά' }, status: :unprocessable_entity
        else
          send_like
        end
      end

      private

      def send_like
        @user.liked_by current_user
        likes.add_notifications(@user)

        render json: { message: true }, status: :ok
      end

      def set_user
        @user = ::User.find_by!(username: params[:username])
        authorize @user
      end

      def likes
        @likes ||= Services::Likes.new(current_user, params[:page])
      end
    end
  end
end
