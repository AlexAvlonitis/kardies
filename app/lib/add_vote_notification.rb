class AddVoteNotification
  def initialize(user, current_user)
    @user, @current_user = user, current_user
  end

  def add
    create_vote_notification
  end

  private

  attr_reader :user, :current_user

  def create_vote_notification
    VoteNotification
      .create(
        user_id: user.id,
        voted_by_id: current_user.id,
        vote: true
      )
  end
end
