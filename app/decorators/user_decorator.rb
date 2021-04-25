class UserDecorator
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
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
    user.email_preference&.messages && !user.is_signed_in
  end

  def profile_picture_attached?
    user.user_detail.profile_picture.attached?
  end

  private

  attr_reader :user

  def picture_variant(size = nil)
    return user.user_detail.profile_picture.variant(resize: size) if size

    user.user_detail.profile_picture
  end
end
