class SuggestedUsers
  def initialize(current_user)
    @current_user = current_user
    @users = []
  end

  def process
    users << find_by_state_and_prefered_gender
    users << find_by_gender if users.empty?
    normalize_and_shuffle_users
  end

  private

  attr_reader :current_user, :users

  def find_by_state_and_prefered_gender
    User.includes(:user_detail).where(
      user_details: {
        gender: gender_of_interest,
        state: current_user.state
      }
    ).limit(4)
  end

  def find_by_gender
    User.includes(:user_detail).where(
      user_details: {
        gender: gender_of_interest
      }
    ).limit(4)
  end

  def gender_of_interest
    return 'female' if current_user.gender == 'male'
    'male'
  end

  def normalize_and_shuffle_users
    users.flatten.shuffle.uniq
  end
end
