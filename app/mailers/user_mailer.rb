class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email.to_s, subject: 'Καλώς ήλθατε στο Kardies.gr')
  end
end
