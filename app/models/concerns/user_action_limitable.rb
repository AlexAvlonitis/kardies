# Usage example for UserActionLimit
# This can be added to User model or as a concern for easy access
module UserActionLimitable
  extend ActiveSupport::Concern

  def can_perform_action?(action_type)
    limit = UserActionLimit.find_or_create_by!(user: self, action_type: action_type) do |l|
      l.count = 0
      l.last_reset_at = Time.current
    end

    limit.can_perform?(is_premium: premium?)
  end

  def increment_action_count!(action_type)
    limit = UserActionLimit.find_or_initialize_by(
      user: self,
      action_type: action_type
    )
    limit.increment_count!
  end
end
