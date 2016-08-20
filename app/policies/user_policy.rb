class UserPolicy < ApplicationPolicy

  def index?
    is_owner?
  end

  def create?
    is_not_owner?
  end

  private

  def is_owner?
    record == user
  end

  def is_not_owner?
    record != user
  end
end
