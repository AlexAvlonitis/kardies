module Likes
  class CreateLikesNotificationsJob < ApplicationJob
    queue_as :default

    def perform(user, current_user)
      VoteNotification.create(
          user_id: user.id,
          voted_by_id: current_user.id,
          vote: true
        )
    end
  end
end
