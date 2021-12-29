module Likes
  class GetAllLikesQuery
    def self.call(current_user)
      new(current_user).call
    end

    def initialize(current_user)
      @current_user = current_user
    end

    def call
      current_user.votes_for.order(newest_likes_first).voters.compact
    end

    private

    attr_reader :current_user

    def newest_likes_first
      { created_at: :desc }
    end
  end
end
