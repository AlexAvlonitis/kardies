class UserActionLimit < ApplicationRecord
  belongs_to :user

  ACTION_LIMITS = {
    'message' => 10,
    'like' => 5,
    'like_index' => 0 # 0 means not allowed for free users
  }.freeze

  # Check if user can perform the action
  def can_perform?(is_premium: false)
    return true if is_premium
    return false if limit.zero?

    reset_if_needed
    count < limit
  end

  def limit
    ACTION_LIMITS[action_type] || 0
  end

  # Increment the count for the action
  def increment_count!
    reset_if_needed
    update!(count: count + 1)
  end

  # Reset count if period has passed
  def reset_if_needed
    return unless last_reset_at

    reset_count! if last_reset_at < 1.day.ago
  end

  def reset_count!
    update!(count: 0, last_reset_at: Time.current)
  end
end
