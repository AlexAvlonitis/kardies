class UserObserver < ActiveRecord::Observer
  def after_create(user)
    send_welcome_mail(user)
    auto_like(user)
  end

  def after_confirmation(user)
    ::News::Users::CreatedJob.perform_later(user)
  end

  def before_destroy(user)
    ::News::Users::DestroyedJob.perform_later(user)
  end

  private

  def send_welcome_mail(user)
    ::UserMailer.welcome_email(user).deliver_later
  end

  def auto_like(user)
    likes_service(user).auto_like
  end

  def likes_service(user)
    @likes_service ||= ::LikesService.new(user)
  end
end
