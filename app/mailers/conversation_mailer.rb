class ConversationMailer < ApplicationMailer
  def message_notification(user)
    @user = user
    mail(to: @user.email.to_s,
         subject: "Έχετε νέο μήνυμα #{@user.username}! Kardies.gr")
  end
end
