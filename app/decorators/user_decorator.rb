class UserDecorator < BaseDecorator
  include Rails.application.routes.url_helpers

  def after_create
    send_welcome_mail
    auto_like
  end

  def after_confirmation
    ::News::User::CreatedJob.perform_later(object)
  end

  def before_destroy
    ::News::User::DestroyedJob.perform_later(object)
  end

  def profile_picture_thumb
    return unless profile_picture_attached?

    pic = picture_variant("100x100>")
    rails_representation_url(pic)
  end

  def profile_picture_medium
    return unless profile_picture_attached?

    pic = picture_variant("300x300>")
    rails_representation_url(pic)
  end

  def profile_picture
    return unless profile_picture_attached?

    rails_blob_url(picture_variant)
  end

  def message_email_notification_allowed?
    email_preference&.messages && !is_signed_in
  end

  def profile_picture_attached?
    user_detail.profile_picture.attached?
  end

  private

  def picture_variant(size = nil)
    return user_detail.profile_picture.variant(resize: size) if size

    user_detail.profile_picture
  end

  def send_welcome_mail
    ::UserMailer.welcome_email(object).deliver_later
  end

  def auto_like
    likes_service(object).auto_like
  end

  def likes_service
    @likes_service ||= ::LikesService.new(object)
  end
end
