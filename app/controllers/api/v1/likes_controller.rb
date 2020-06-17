module Api
  module V1
    class LikesController < ApiController
      before_action :set_user, except: [:index]

      def index
        likes_service.delete_all_notifications
        render json: likes_service.sorted, status: :ok
      end

      def create
        return send_like unless current_user.voted_for?(@user)

        render json: { errors: 'Έχετε ήδη στείλει καρδιά' }, status: :unprocessable_entity
      end

      private

      def send_like
        @user.liked_by(current_user)
        likes_service.add_notifications(@user)

        render json: { message: true }, status: :ok
      end

      def set_user
        @user = ::User.find_by!(username: params[:username])
        authorize(@user)
      end

      def likes_service
        @likes_service ||= Services::Likes.new(current_user, params[:page])
      end
    end
  end
end
