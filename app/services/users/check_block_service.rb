module Users
  class CheckBlockService < BaseService
    def initialize(current_user, user)
      @current_user = current_user
      @user = user
    end

    def call
      blocked_by_current_user? || blocked_by_user?
    end

    private

    attr_reader :current_user, :user

    def blocked_by_current_user?
      user.blocked_users.exists?(blocked_user_id: current_user.id)
    end

    def blocked_by_user?
      current_user.blocked_users.exists?(blocked_user_id: user.id)
    end
  end
end
