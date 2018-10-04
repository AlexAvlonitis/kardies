module Services
  class UserBlockedCheck
    def self.execute(current_user, user)
      blocked_by_current_user =
        user.blocked_users.find_by(blocked_user_id: current_user.id)

      blocked_by_user =
        current_user.blocked_users.find_by(blocked_user_id: user.id)

      return true if blocked_by_current_user || blocked_by_user
    end
  end
end
