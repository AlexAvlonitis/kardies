class HeartsMailer < ApplicationMailer
  def new_hearts_notification(user)
    @user = user
    mail(to: @user.email.to_s, subject: 'New hearts! kardies.gr')
  end
end
