class UserPolicy < ApplicationPolicy
  def index?
    owner?
  end

  def create?
    !owner? && !blocked?
  end

  def show?
    !blocked?
  end

  def authorize_admin?
    admin?
  end

  def admin_unblock?
    admin?
  end

  def admin_destroy?
    admin?
  end

  private

  def blocked?
    if Services::UserBlockedCheck.execute(user, record)
      raise Pundit::NotAuthorizedError.new({
        query: :blocked?,
        record: record,
        policy: Pundit.policy(user, record)
      })
    end
  end

  def admin?
    user.admin?
  end

  def owner?
    record == user
  end
end
