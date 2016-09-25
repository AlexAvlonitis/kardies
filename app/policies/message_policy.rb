class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.where(user_id: user.id, deleted_inbox: nil)
      end
    end
  end

  def delete_received?
    is_message_owner?
  end

  private

  def is_message_owner?
    record.user_id == user.id
  end
end
