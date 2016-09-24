class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.where(user_id: user.id)
      end
    end
  end
end
