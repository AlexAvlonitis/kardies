class UserDecorator < SimpleDelegator
  def save
    super
    send_welcome_mail
    auto_like
  end

  def after_confirmation
    ::News::User::CreatedJob.perform_later(__getobj__)
  end

  def destroy
    ::News::User::DestroyedJob.perform_later(__getobj__)
    super
  end

  private

  def send_welcome_mail
    ::UserMailer.welcome_email(__getobj__).deliver_later
  end

  def auto_like
    likes_service.auto_like
  end

  def likes_service
    @likes_service ||= ::LikesService.new(__getobj__)
  end
end
