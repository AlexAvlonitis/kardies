module Api
  module V1
    class LikesController < ApiController
      before_action :set_user, :validate_likes_limit, only: :create
      before_action :delete_likes_notifications, only: :index

      def index
        likes = Likes::GetAllLikesQuery.call(current_user)
        unless current_user.can_perform_action?('like_index')
          likes = obfuscated_likes_list(likes)
        end

        paginated_likes = Kaminari.paginate_array(likes).page(params[:page])

        render json: paginated_likes, status: :ok
      end

      def create
        if current_user.voted_for?(@user)
          render json: { errors: 'Έχετε ήδη στείλει καρδιά' }, status: :conflict
        else
          @user.liked_by(current_user)
          create_notification
          current_user.increment_action_count!('like')

          render json: { message: true }, status: :ok
        end
      end

      private

      def set_user
        @user = ::User.find_by!(username: params[:username])
        authorize(@user)
      end

      def validate_likes_limit
        unless current_user.can_perform_action?('like')
          render json: {
            error: "Έχετε φτάσει το όριο των #{UserActionLimit::ACTION_LIMITS['like']} καρδιών την ημέρα. " \
                    "Αναβαθμίστε για απεριόριστες καρδιές."
          }, status: :forbidden
        end
      end

      # creates the same amount of users with obfuscated data
      def obfuscated_likes_list(likes)
        likes_count = likes.count
        obfuscated_users = []
        likes_count.times do |i|
          obfuscated_users << {
            id: i + 1,
            obfuscated: true,
            username: "user#{i + 1}",
            profile_picture_thumb: nil,
            profile_picture_medium: nil
          }
        end
        obfuscated_users
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
