module Services
  class Likes
    def initialize(current_user, page = nil)
      @current_user = current_user
      @page = page
    end

    def sorted(options = {created_at: :desc})
      @likes = current_user.votes_for.order(options).voters
      paginate
    end

    def add_notifications(user)
      add_vote_notification(user)
      send_notification_email(user)
    end

    def delete_vote_notification
      VoteNotification.find_by(voted_by_id: current_user.id)&.destroy
    end

    def delete_all_notifications
      current_user.vote_notifications.destroy_all
    end

    def auto_like
      current_user.liked_by nini_user
      add_vote_notification(nini_user)
    end

    private

    attr_reader :current_user, :page

    def paginate
      ::Kaminari.paginate_array(@likes).page(page)
    end

    def send_notification_email(user)
      Notifications::Hearts.new(user).execute
    end

    def nini_user
      @nini_user ||= User.find_by(email: 'ni_ni9001@hotmail.com')
    end

    def add_vote_notification(user)
      VoteNotification
        .create(
          user_id: user.id,
          voted_by_id: current_user.id,
          vote: true
        )
    end
  end
end
