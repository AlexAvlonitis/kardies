class UserObserver < ActiveRecord::Observer
  def after_create(user)
    send_welcome_mail(user)
    auto_like(user)
  end

  def after_confirmation(user)
    New.create(
      title: "Νέος χρήστης! #{user.username}",
      body: "Ο/Η #{user.username} έγινε μέλος της παρέας μας!"
    )
  end

  def before_destroy(user)
    user.messages.destroy_all
  end

  private

  def send_welcome_mail(user)
    UserMailer.welcome_email(user).deliver_later
  end

  def auto_like(user)
    likes_service(user).auto_like
  end

  def likes_service(user)
    @likes_service ||= Services::Likes.new(user)
  end
end
