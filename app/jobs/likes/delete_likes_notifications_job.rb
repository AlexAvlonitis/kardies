module Likes
  class DeleteLikesNotificationsJob < ApplicationJob
    queue_as :default

    def perform(current_user)
      current_user.vote_notifications.destroy_all
    end
  end
end
