class UserPolicy < ApplicationPolicy
  def index?
    owner?
  end

  def create?
    !owner? && !blocked?
  end

  def golden_like?
    !owner? && !blocked?
  end

  def show?
    !blocked? && !profile_pic_exists?
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
    if Users::CheckBlockService.call(user, record)
      raise Pundit::NotAuthorizedError.new(
        query: :blocked?,
        record: record,
        policy: Pundit.policy(user, record)
      )
    end
  end

  def profile_pic_exists?
    return if record == user
    return if user_presenter.profile_picture_attached?

    raise Pundit::NotAuthorizedError.new(
      query: :profile_pic_exists?,
      record: record,
      policy: Pundit.policy(user, record)
    )
  end

  def admin?
    user.admin?
  end

  def owner?
    record == user
  end

  def user_presenter
    @user_presenter ||= UserPresenter.new(user)
  end
end
