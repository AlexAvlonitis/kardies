class UserPolicy < ApplicationPolicy
  def update?
    current_user == @user
  end
end
