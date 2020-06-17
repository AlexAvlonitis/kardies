class GoldenHeartMailer < ApplicationMailer
  def new_hearts_notification(user)
    @user = user
    mail(to: @user.email.to_s, subject: 'Νέα χρυσή καρδιά! kardies.gr')
  end
end
