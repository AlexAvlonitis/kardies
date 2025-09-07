module Likes
  class AutoLikeService
    BOT_USER_ID = 1

    def self.call(current_user)
      bot_user = User.find_by(id: BOT_USER_ID)
      new(current_user, bot_user).call
    end

    def initialize(current_user, bot_user)
      @current_user = current_user
      @bot_user = bot_user
    end

    def call
      current_user.liked_by(bot_user)
      create_notifaction
    end

    private

    attr_reader :current_user, :bot_user

    def create_notifaction
      Likes::CreateLikesNotificationsJob.perform_later(bot_user, current_user)
    end
  end
end
