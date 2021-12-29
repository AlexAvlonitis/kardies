module Api
  module V1
    class LikesController < ApiController
      before_action :set_user, only: :create
      before_action :delete_likes_notifications, only: :index

      def index
        likes = Likes::GetAllLikesQuery.call(current_user)
        paginated_likes = Kaminari.paginate_array(likes).page(params[:page])

        render json: paginated_likes, status: :ok
      end

      def create
        if current_user.voted_for?(@user)
          @user.liked_by(current_user)
          create_notification

          render json: { message: true }, status: :ok
        else
          render json: { errors: 'Έχετε ήδη στείλει καρδιά' }, status: :conflict
        end
      end

      private

      def set_user
        @user = ::User.find_by!(username: params[:username])
        authorize(@user)
      end

      def delete_likes_notifications
        Likes::DeleteLikesNotificationsJob.perform_later(current_user)
      end

      def create_notification
        Likes::CreateLikesNotificationsJob.perform_later(@user, current_user)
      end
    end
  end
end
