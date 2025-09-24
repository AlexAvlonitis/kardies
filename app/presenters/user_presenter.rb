class UserPresenter
  include Rails.application.routes.url_helpers

  def initialize(user_model)
    @user_model = user_model
  end

  def profile_picture_thumb
    return unless profile_picture_attached?

    pic = picture_variant("100x100>")
    rails_representation_url(pic, only_path: true)
  end

  def profile_picture_medium
    return unless profile_picture_attached?

    pic = picture_variant("300x300>")
    rails_representation_url(pic, only_path: true)
  end

  def profile_picture
    return unless profile_picture_attached?

    rails_blob_url(picture_variant, only_path: true)
  end

  def message_email_notification_allowed?
    user_model.email_preference&.messages && !user_model.is_signed_in
  end

  def profile_picture_attached?
    user_model.user_detail.profile_picture.attached?
  end

  private

  attr_reader :user_model

  def picture_variant(size = nil)
    return user_model.user_detail.profile_picture unless size

    user_model.user_detail.profile_picture.variant(resize: size)
  end
end
