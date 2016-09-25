class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.where(user_id: user.id, deleted_inbox: nil)
      end
    end
  end
end
