class ConversationMailer < ApplicationMailer
  def message_notification(user)
    attachments.inline['hearts-logo-small.png'] = File.read('public/images/hearts-logo-small.png')

    @user = user
    mail(to: @user.email.to_s,
         subject: "Έχετε νέο μήνυμα #{@user.username}! Kardies.gr")
  end
end
