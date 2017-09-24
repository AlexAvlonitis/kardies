class SuggestedUsers
  def initialize(current_user)
    @current_user = current_user
    @users = []
  end

  def process
    if find_by_state_and_prefered_gender.empty?
      users << find_by_gender
    else
      users << find_by_state_and_prefered_gender
    end
    normalize_users
  end

  private

  attr_reader :current_user, :users

  def find_by_state_and_prefered_gender
    User.get_by_state_and_prefered_gender(current_user, gender_of_interest)
  end

  def find_by_gender
    User.get_by_gender(current_user, gender_of_interest)
  end

  def gender_of_interest
    return 'female' if current_user.gender == 'male'
    'male'
  end

  def normalize_users
    users.flatten.uniq
  end
end
