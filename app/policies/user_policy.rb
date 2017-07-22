class UserPolicy < ApplicationPolicy
  def index?
    owner?
  end

  def create?
    not_owner?
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

  def admin?
    user.admin?
  end

  def owner?
    record == user
  end

  def not_owner?
    record != user
  end
end
