class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.where(user_id: user.id, deleted_inbox: nil)
      end
    end
  end

  def delete_received?
    is_inbox_owner?
  end

  def delete_sent?
    is_sent_owner?
  end

  private

  def is_inbox_owner?
    record.user_id == user.id
  end

  def is_sent_owner?
    record.posted_by == user.id
  end
end
