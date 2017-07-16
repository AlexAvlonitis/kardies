class UserPolicy < ApplicationPolicy
  def index?
    owner?
  end

  def create?
    not_owner?
  end

  private

  def owner?
    record == user
  end

  def not_owner?
    record != user
  end
end
