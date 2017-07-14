class UserMailer < ApplicationMailer
  def welcome_email(user)
    attachments.inline['hearts_2.png'] = File.read('public/images/hearts_2.png')

    @user = user
    mail(to: @user.email.to_s,
         subject: 'Καλώς ήλθατε στο Kardies.gr')
  end
end
