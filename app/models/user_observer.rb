class UserObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers

  def after_create(user)
    send_welcome_mail(user)
    auto_like(user)
  end

  def after_confirmation(user)
    News::Users::Created.create(
      meta: {
        username: user.username,
        profile_picture: rails_representation_url(user.profile_picture_thumb)
      }.to_json
    )
  end

  def before_destroy(user)
    News::Users::Destroyed.create(
      meta: {
        username: user.username
      }.to_json
    )
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
