module Api
  module V1
    class LikesController < ApiController
      before_action :set_user, only: :create

      def index
        likes.delete_all_notifications
        render json: likes.sorted, status: :ok
      end

      def create
        return send_like unless current_user.voted_for? @user
        return send_unlike if current_user.voted_for? @user
      end

      private

      def send_unlike
        @user.unliked_by current_user
        likes.delete_vote_notification

        render json: { "heart": 'fa-heart-o' }, status: :ok
      end

      def send_like
        @user.liked_by current_user
        likes.add_notifications(@user)

        render json: { "heart": 'fa-heart' }, status: :ok
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
