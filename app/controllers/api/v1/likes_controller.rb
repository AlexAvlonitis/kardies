module Api
  module V1
    class LikesController < ApiController
      before_action :set_user, only: :like

      def index
        current_user.vote_notifications.destroy_all
        all_likes_sorted
        suggested_users
      end

      def like
        if ::UserBlockedCheck.call(current_user, @user)
          render json: {
              errors: "#{t ('users.show.blocked_user')}"
            },
            status: :forbidden
          return
        end
        return send_unlike if current_user.voted_for? @user
        return send_like unless current_user.voted_for? @user
      rescue ::StandardError => e
        render json: { errors: e }, status: 422
      end

      private

      def send_unlike
        delete_vote_notification
        @user.unliked_by current_user
        render json: { "heart": 'fa-heart-o' }, status: :ok
      end

      def send_like
        @user.liked_by current_user
        add_vote_notification
        send_notification_email
        render json: { "heart": 'fa-heart' }, status: :ok
      end

      def add_vote_notification
        @add_vote_notification ||=
          ::AddVoteNotification.new(@user, current_user).add
      end

      def set_user
        @user = ::User.find_by(username: params[:username])
        rescue_error unless @user
      end

      def delete_vote_notification
        vote = ::VoteNotification.find_by(voted_by_id: current_user.id)
        vote ? vote.destroy! : return
      end

      def send_notification_email
        ::HeartsNotificationEmail.new(@user).send
      end

      def suggested_users
        @suggested_users ||= ::SuggestedUsers.new(current_user).process
      end

      def all_likes_sorted
        likes = current_user.votes_for.order(created_at: :desc).voters
        @likes ||= ::Kaminari.paginate_array(likes).page(params[:page])
      end
    end
  end
end
