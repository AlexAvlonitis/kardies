class HeartsMailer < ApplicationMailer
  def new_hearts_notification(user)
    attachments.inline['hearts_2.png'] = File.read('public/images/hearts_2.png')

    @user = user
    mail(to: @user.email.to_s, subject: 'New hearts! kardies.gr')
  end
end
