class AutoLike
  def initialize(current_user)
    @current_user = current_user
  end

  def like
    nini_user.likes current_user
    add_vote_notification
  end

  private

  attr_reader :current_user

  def nini_user
    @nini_user ||= User.find_by(email: 'ni_ni9001@hotmail.com')
  end

  def add_vote_notification
    VoteNotification
      .create(
        user_id: nini_user.id,
        voted_by_id: current_user.id,
        vote: true
      )
  end
end
