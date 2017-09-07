class AddVoteNotification
  def initialize(user, current_user)
    @user, @current_user = user, current_user
  end

  def add
    VoteNotification.create(user_id: user.id,
                            voted_by_id: current_user.id,
                            vote: true)
  end

  private

  attr_reader :user, :current_user
end
