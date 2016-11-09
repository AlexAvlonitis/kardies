class LikesController < ApplicationController

  def index
    current_user.vote_notifications.destroy_all
    @likes = current_user.votes_for.voters
  end

end
